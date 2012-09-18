#import <Foundation/Foundation.h>

@class CAGradientLayer;


@interface MyButton : UIButton
@property(nonatomic, strong) UIColor* rootColor;
@property(nonatomic, copy) NSString* text;
@property(nonatomic, retain) CAGradientLayer* glareLayer;
@property(nonatomic) CGFloat textHeight;
@property(nonatomic) float cornerRadius;
@property(nonatomic) float padding;
@property(nonatomic, retain) UIColor* borderColor;
@end