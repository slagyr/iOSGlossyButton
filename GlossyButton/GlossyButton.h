#import <Foundation/Foundation.h>

@class CAGradientLayer;


@interface GlossyButton : UIButton
@property(nonatomic, copy) NSString* text;
@property(nonatomic, strong) UIColor* rootColor;
@property(nonatomic, retain) UIColor* borderColor;
@property(nonatomic) float cornerRadius;
@property(nonatomic) bool topLeftRounded;
@property(nonatomic) bool topRightRounded;
@property(nonatomic) bool bottomRightRounded;
@property(nonatomic) bool bottomLeftRounded;
@property(nonatomic) float topBorderWidth;
@property(nonatomic) float rightBorderWidth;
@property(nonatomic) float bottomBorderWidth;
@property(nonatomic) float leftBorderWidth;
@end