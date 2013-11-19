#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    // Set to first responder then listen for motion events
    [self becomeFirstResponder];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	
	if(event.subtype == UIEventSubtypeMotionShake){
		NSLog(@"motionBegan");
	}
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	
	if(event.subtype == UIEventSubtypeMotionShake){
		NSLog(@"motionCancelled");
	}
	
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	
	if(event.subtype == UIEventSubtypeMotionShake){
		NSLog(@"motionEnded");
	}
}

// Allow controller to become first responder
- (BOOL)canBecomeFirstResponder
{ 
    return YES; 
}

@end
