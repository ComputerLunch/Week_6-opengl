

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    float val1;
    float val2;
    float val3;
    float val4;
    float val5;
    float val6;

    UIImageView * drawImage;
    UIImageView * maskedImg;
    UIImageView * maskLayer;
    
    UISlider *sliderVal1;
    UISlider *sliderVal2;
    UISlider *sliderVal3;
    UISlider *sliderVal4;
    UISlider *sliderVal5;
    UISlider *sliderVal6;
}
@property (retain, nonatomic) IBOutlet UISlider *sliderVal1;
@property (retain, nonatomic) IBOutlet UISlider *sliderVal2;
@property (retain, nonatomic) IBOutlet UISlider *sliderVal3;
@property (retain, nonatomic) IBOutlet UISlider *sliderVal4;
@property (retain, nonatomic) IBOutlet UISlider *sliderVal5;
@property (retain, nonatomic) IBOutlet UISlider *sliderVal6;

-(IBAction)updateVal1:(UISlider *)sender;
-(IBAction)updateVal2:(UISlider *)sender;
-(IBAction)updateVal3:(UISlider *)sender;
-(IBAction)updateVal4:(UISlider *)sender;
-(IBAction)updateVal5:(UISlider *)sender;
-(IBAction)updateVal6:(UISlider *)sender;

@end
