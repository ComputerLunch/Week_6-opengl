#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize sliderVal1;
@synthesize sliderVal2;
@synthesize sliderVal3;
@synthesize sliderVal4;
@synthesize sliderVal5;
@synthesize sliderVal6;

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor redColor];
    
    val1 = 0.5;
    val2 = 0.5;
    val3 = 0.5;
    val4 = 0.5;
    val5 = 0.5;
    val6 = 0.5;
    
    drawImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //drawImage.backgroundColor = [UIColor lightGrayColor];
    //[self.view insertSubview:drawImage atIndex:0];
    
    maskedImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //drawImage.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:maskedImg];
    
    maskLayer = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //maskImage.backgroundColor = [UIColor lightGrayColor];
    [self.view insertSubview:maskLayer atIndex:0];
    
    
    drawImage.image = [UIImage imageNamed:@"green_screen.jpg"];//[UIImage imageNamed:@"obama.jpeg"];
    
    // init values
    val1 = sliderVal1.value;
    val2 = sliderVal2.value;
    val3 = sliderVal3.value;
    val4 = sliderVal4.value;
    val5 = sliderVal5.value;
    val6 = sliderVal6.value;
    maskLayer.image = [self maskImage];
}

- (UIImage*) maskImage{
    
	//CGImageRef maskRef = maskImage.CGImage; 
    
    
    //CGImageRef myMaskedImage;
    
    const float myMaskingColors[6] = {val1 * 255, val2 * 255,  val3 * 255, val4 * 255, val5 * 255, val6 * 255};
    
    
    CGImageRef myColorMaskedImage = CGImageCreateWithMaskingColors (drawImage.image.CGImage, myMaskingColors);
    

	//CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	return [UIImage imageWithCGImage:myColorMaskedImage];
    
}


-(IBAction)updateVal1:(UISlider *)sender{  
    NSLog(@"slide");
    val1 = sender.value;
    maskLayer.image = [self maskImage];
}
-(IBAction)updateVal2:(UISlider *)sender{
     val2 = sender.value;
    maskLayer.image = [self maskImage];
}
-(IBAction)updateVal3:(UISlider *)sender{
     val3 = sender.value;
    maskLayer.image = [self maskImage];
}
-(IBAction)updateVal4:(UISlider *)sender{
     val4 = sender.value;
     maskLayer.image = [self maskImage];
}
-(IBAction)updateVal5:(UISlider *)sender{
     val5 = sender.value;
     maskLayer.image = [self maskImage];
}
-(IBAction)updateVal6:(UISlider *)sender{
    val6 = sender.value;
    maskLayer.image = [self maskImage];
}
@end
