#import "GlossyButton.h"
#import <QuartzCore/QuartzCore.h>


@interface GlossyButton ()

@property (readwrite, assign) CAGradientLayer* backgroundLayer;
@property (readwrite, assign) CAGradientLayer* foregroundLayer;
@property (readwrite, assign) CATextLayer* textLayer;

@end

@implementation GlossyButton

- (id) initWithCoder:(NSCoder*)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.cornerRadius = 9.0;
    self.padding = 1.0;
    self.borderColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0];
  }

  return self;
}

- (void) awakeFromNib {
  [super awakeFromNib];
  self.rootColor = self.backgroundColor == nil ? [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0] : self.backgroundColor;
  self.layer.backgroundColor = [UIColor clearColor].CGColor;
}

- (void) buildTextLayer {
  self.textLayer = [CATextLayer layer];
  self.textLayer.string = self.currentTitle;
  self.textLayer.foregroundColor = self.currentTitleColor.CGColor;

  CGFontRef font = CGFontCreateWithFontName((void*)self.titleLabel.font.fontName);
  self.textLayer.font = font;
  CGFontRelease(font);

  self.textLayer.fontSize = self.titleLabel.font.pointSize;
  self.textLayer.alignmentMode = kCAAlignmentCenter;

  self.textLayer.shadowColor = self.currentTitleShadowColor.CGColor;
  self.textLayer.shadowOffset = CGSizeMake(0.0, -1.0);
  self.textLayer.shadowOpacity = 1.0;
  self.textLayer.shadowRadius = 0.0;
  self.textLayer.contentsScale = [[UIScreen mainScreen] scale];

  CGSize textSize = [self.textLayer.string sizeWithFont:self.titleLabel.font];
  self.textHeight = textSize.height + self.titleLabel.font.descender;

  [self.foregroundLayer addSublayer:self.textLayer];
}

- (void) buildForegroundLayer {
  self.foregroundLayer = [CAGradientLayer layer];

  UIColor* lighterColor = [self lighterColor:self.rootColor];
  self.foregroundLayer.colors = @[(id)lighterColor.CGColor,(id)self.rootColor.CGColor];
  self.foregroundLayer.locations = @[@(0.0), @(1.0)];
  self.foregroundLayer.cornerRadius = self.cornerRadius - 1.0;

  self.foregroundLayer.shadowColor = [UIColor lightGrayColor].CGColor;
  self.foregroundLayer.shadowOffset = CGSizeMake(0.0, -1.0);
  self.foregroundLayer.shadowOpacity = 0.5;
  self.foregroundLayer.shadowRadius = 1.0;
  self.foregroundLayer.contentsScale = [[UIScreen mainScreen] scale];
  [self.backgroundLayer addSublayer:self.foregroundLayer];
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

- (void) buildGlareLayer {
  self.glareLayer = [CAGradientLayer layer];

  UIColor* top = [UIColor colorWithWhite:1.0 alpha:0.70];
  UIColor* bottom = [UIColor colorWithWhite:1.0 alpha:0.15];

  self.glareLayer.colors = @[(id)top.CGColor,(id)bottom.CGColor];
  self.glareLayer.locations = @[@(0.0), @(1.0)];
  self.glareLayer.contentsScale = [[UIScreen mainScreen] scale];
  [self.foregroundLayer addSublayer:self.glareLayer];
}

- (void) buildBackgroundLayer {
  self.backgroundLayer = [CAGradientLayer layer];
  UIColor* lighterColor = [self lighterColor:self.borderColor];
  self.backgroundLayer.colors = @[(id) lighterColor.CGColor,(id)self.borderColor.CGColor];
  self.backgroundLayer.locations = @[@(0.0), @(1.0)];
  self.backgroundLayer.cornerRadius = self.cornerRadius;
  self.backgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
  [self.layer addSublayer:self.backgroundLayer];
}

- (void)layoutSubviews {
  [self layoutBackgroundLayer];
  [self layoutForeground];
  [self layoutGlare];
  [self layoutText];
}

- (void) layoutBackgroundLayer {
  if(self.backgroundLayer == nil)
    [self buildBackgroundLayer];
  self.backgroundLayer.frame = self.layer.bounds;
}

- (void) layoutText {
  if(self.textLayer == nil)
    [self buildTextLayer];
  CGRect textBounds = self.foregroundLayer.bounds;

  CGFloat yInset = (textBounds.size.height - self.textHeight) / 2.0;

  textBounds = CGRectInset(textBounds, 0.0, yInset);
  self.textLayer.frame = textBounds;
}

- (void) layoutForeground {
  if (self.foregroundLayer == nil)
    [self buildForegroundLayer];
  CGRect innerRect = CGRectInset(self.backgroundLayer.frame, self.padding, self.padding);
  self.foregroundLayer.frame = innerRect;
}

- (void) layoutGlare {
  if(self.glareLayer == nil)
    [self buildGlareLayer];
  CGRect glareBounds = self.foregroundLayer.bounds;
  glareBounds.size.height = glareBounds.size.height / 2.0 - 1;
  self.glareLayer.frame = glareBounds;
  float radius = self.cornerRadius - 2.0;
  UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.glareLayer.bounds
                                                 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                       cornerRadii:CGSizeMake(radius, radius)];

  CAShapeLayer* maskLayer = [CAShapeLayer layer];
  maskLayer.frame = self.glareLayer.bounds;
  maskLayer.path = maskPath.CGPath;

  self.glareLayer.mask = maskLayer;
}

@end
