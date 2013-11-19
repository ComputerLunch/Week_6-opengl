#import <UIKit/UIKit.h>

@interface ColorUIButton : UIButton{

    float size;
    UIColor * color;
    BOOL isSelected;

}

@property float size;
@property BOOL isSelected;
@property(retain, nonatomic)   UIColor * color;


- (id)initWithFrame:(CGRect)frame brushSize:(float)tempSize color:(UIColor *)tempColor;

@end