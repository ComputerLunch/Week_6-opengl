#import <UIKit/UIKit.h>

@interface CutOutUIButton : UIButton{
    
    UIButton * button; 
    NSString * imageName;
    UIImageView * lock;
    
}
@property(retain, nonatomic) UIButton * button;
@property(nonatomic,retain)NSString * imageName;
@property(nonatomic,retain)UIImageView * lock;

-(id)initWithFrame:(CGRect)frame name:(NSString *)tempName;

@end
