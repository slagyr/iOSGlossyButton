#import "GlossyButton.h"
#import <QuartzCore/QuartzCore.h>


@interface GlossyButton ()

@property(readwrite, assign) CAGradientLayer* backgroundLayer;
@property(readwrite, assign) CAGradientLayer* foregroundLayer;
@property(nonatomic, retain) CAGradientLayer* glareLayer;
@property(readwrite, assign) CATextLayer* textLayer;
@property(readwrite, assign) CALayer* highlightLayer;
@property(nonatomic) CGFloat textHeight;

@end

@implementation GlossyButton

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self)
    [self initDefaultProperties];
  return self;
}

- (id) initWithCoder:(NSCoder*)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self)
    [self initDefaultProperties];
  return self;
}

- (void) initDefaultProperties {
  self.rootColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
  self.cornerRadius = 9.0;
  self.topLeftRounded = true;
  self.topRightRounded = true;
  self.bottomRightRounded = true;
  self.bottomLeftRounded = true;
  [self setBorderWidth:1.0];
  self.borderColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0];
}

- (void) setBorderWidth:(float)w {
  self.topBorderWidth = w;
  self.rightBorderWidth = w;
  self.bottomBorderWidth = w;
  self.leftBorderWidth = w;
}

- (void) awakeFromNib {
  [super awakeFromNib];
  if (self.backgroundColor)
    self.rootColor = self.backgroundColor;
  self.layer.backgroundColor = [UIColor clearColor].CGColor;
}

- (UIColor*) lighterColor:(UIColor*)color {
  CGFloat r, g, b;
  [color getRed:&r green:&g blue:&b alpha:NULL];
  r = MIN(1.0, r * 1.25);
  g = MIN(1.0, g * 1.25);
  b = MIN(1.0, b * 1.25);
  UIColor* lighterColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
  return lighterColor;
}

- (void) buildTextLayer {
  self.textLayer = [CATextLayer layer];

  CGFontRef font = CGFontCreateWithFontName((void*) self.titleLabel.font.fontName);
  self.textLayer.font = font;
  CGFontRelease(font);

  self.textLayer.fontSize = self.titleLabel.font.pointSize;
  self.textLayer.alignmentMode = kCAAlignmentCenter;

  self.textLayer.shadowOffset = CGSizeMake(0.0, -1.0);
  self.textLayer.shadowOpacity = 1.0;
  self.textLayer.shadowRadius = 0.0;
  self.textLayer.contentsScale = [[UIScreen mainScreen] scale];

  CGSize textSize = [@"Aj" sizeWithFont:self.titleLabel.font];
  self.textHeight = textSize.height + self.titleLabel.font.descender;

  [self.foregroundLayer addSublayer:self.textLayer];
}

- (void) buildForegroundLayer {
  self.foregroundLayer = [CAGradientLayer layer];

  UIColor* lighterColor = [self lighterColor:self.rootColor];
  self.foregroundLayer.colors = @[(id) lighterColor.CGColor, (id) self.rootColor.CGColor];
  self.foregroundLayer.locations = @[@(0.0), @(1.0)];

  self.foregroundLayer.shadowColor = [UIColor lightGrayColor].CGColor;
  self.foregroundLayer.shadowOffset = CGSizeMake(0.0, -1.0);
  self.foregroundLayer.shadowOpacity = 0.5;
  self.foregroundLayer.shadowRadius = 1.0;
  self.foregroundLayer.contentsScale = [[UIScreen mainScreen] scale];
  [self.backgroundLayer addSublayer:self.foregroundLayer];
}

- (void) buildGlareLayer {
  self.glareLayer = [CAGradientLayer layer];

  UIColor* top = [UIColor colorWithWhite:1.0 alpha:0.70];
  UIColor* bottom = [UIColor colorWithWhite:1.0 alpha:0.15];

  self.glareLayer.colors = @[(id) top.CGColor, (id) bottom.CGColor];
  self.glareLayer.locations = @[@(0.0), @(1.0)];
  self.glareLayer.contentsScale = [[UIScreen mainScreen] scale];
  [self.foregroundLayer addSublayer:self.glareLayer];
}

- (void) buildBackgroundLayer {
  self.backgroundLayer = [CAGradientLayer layer];
  UIColor* lighterColor = [self lighterColor:self.borderColor];
  self.backgroundLayer.colors = @[(id) lighterColor.CGColor, (id) self.borderColor.CGColor];
  self.backgroundLayer.locations = @[@(0.0), @(1.0)];
  self.backgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
  [self.layer addSublayer:self.backgroundLayer];
}

- (void) buildHighlightLayer {
  self.highlightLayer = [CALayer layer];
  self.highlightLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
  [self.foregroundLayer addSublayer:self.highlightLayer];
}

- (void) layoutSubviews {
  [self layoutBackgroundLayer];
  [self layoutForeground];
  [self layoutGlare];
  [self layoutHighlight];
  [self layoutText];
  self.highlightLayer.hidden = !self.isHighlighted;
}

- (void) layoutHighlight {
  if (self.highlightLayer == nil)
    [self buildHighlightLayer];
  CGRect frame = self.foregroundLayer.frame;
  frame.origin.x = 0;
  frame.origin.y = 0;
  self.highlightLayer.frame = frame;
  if (self.cornerRadius > 1.0) {
    [self addCornerRadii:self.cornerRadius - 1.0
                 toLayer:self.highlightLayer
                 topLeft:self.topLeftRounded topRight:self.topRightRounded
             bottomRight:self.bottomRightRounded bottomLeft:self.bottomLeftRounded];
  }
}

- (void) layoutBackgroundLayer {
  if (self.backgroundLayer == nil)
    [self buildBackgroundLayer];
  self.backgroundLayer.frame = self.layer.bounds;
  if (self.cornerRadius > 0) {
    [self addCornerRadii:self.cornerRadius
                 toLayer:self.backgroundLayer
                 topLeft:self.topLeftRounded topRight:self.topRightRounded
             bottomRight:self.bottomRightRounded bottomLeft:self.bottomLeftRounded];
  }
}

- (void) layoutText {
  if (self.textLayer == nil)
    [self buildTextLayer];

  self.textLayer.string = self.currentTitle;
  self.textLayer.foregroundColor = self.currentTitleColor.CGColor;
  self.textLayer.shadowColor = self.currentTitleShadowColor.CGColor;

  CGRect textBounds = self.foregroundLayer.bounds;
  CGFloat yInset = (textBounds.size.height - self.textHeight) / 2.0;

  textBounds = CGRectInset(textBounds, 0.0, yInset);
  self.textLayer.frame = textBounds;
}

- (void) layoutForeground {
  if (self.foregroundLayer == nil)
    [self buildForegroundLayer];
  CGRect frame = self.backgroundLayer.frame;
  frame.origin.x = self.leftBorderWidth;
  frame.origin.y = self.topBorderWidth;
  frame.size.width = frame.size.width - self.leftBorderWidth - self.rightBorderWidth;
  frame.size.height = frame.size.height - self.topBorderWidth - self.bottomBorderWidth;
  CGRect innerRect = frame;
  self.foregroundLayer.frame = innerRect;
  if (self.cornerRadius > 1.0) {
    [self addCornerRadii:self.cornerRadius - 1.0
                 toLayer:self.foregroundLayer
                 topLeft:self.topLeftRounded topRight:self.topRightRounded
             bottomRight:self.bottomRightRounded bottomLeft:self.bottomLeftRounded];
  }
}

- (void) layoutGlare {
  if (self.glareLayer == nil)
    [self buildGlareLayer];
  CGRect frame = self.foregroundLayer.bounds;
  frame.size.height = frame.size.height / 2.0 - 1;
  self.glareLayer.frame = frame;
  if (self.cornerRadius > 2.0) {
    [self addCornerRadii:self.cornerRadius - 2.0
                 toLayer:self.glareLayer
                 topLeft:self.topLeftRounded topRight:self.topRightRounded
             bottomRight:false bottomLeft:false];
  }
}

- (void) addCornerRadii:(float)radius toLayer:(CALayer*)layer topLeft:(bool)topLeft topRight:(bool)topRight bottomRight:(bool)bottomRight bottomLeft:(bool)bottomLeft {
  UIRectCorner corners = 0;
  corners |= (topLeft ? UIRectCornerTopLeft : 0);
  corners |= (topRight ? UIRectCornerTopRight : 0);
  corners |= (bottomRight ? UIRectCornerBottomRight : 0);
  corners |= (bottomLeft ? UIRectCornerBottomLeft : 0);
  if (corners == 0)
    return;
  UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                                 byRoundingCorners:corners
                                                       cornerRadii:CGSizeMake(radius, radius)];

  CAShapeLayer* maskLayer = [CAShapeLayer layer];
  maskLayer.frame = layer.bounds;
  maskLayer.path = maskPath.CGPath;
  layer.mask = maskLayer;
}

@end
