#import "ViewController.h"

@interface ViewController (){
    
    UIImageView * ball;
    CGPoint delta;
}

@end



@implementation ViewController

- (void)viewDidLoad
{
    ball = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"donut.png"]];
    ball.frame = CGRectMake(100,100,50,50);
    [self.view addSubview:ball];
    
    UIAccelerometer * accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate = self;
    accel.updateInterval = 1.0f/60.0f;
    
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    printf("x: %0.2f", acceleration.x);
    printf("y: %0.2f", acceleration.y);
    printf("z: %0.2f", acceleration.z);
    
    int speed = 5;
    
    delta.x = acceleration.x * speed;
    delta.y = acceleration.y * speed;
    
    // update ball location
    ball.center = CGPointMake(ball.center.x + delta.x , ball.center.y - delta.y );
    
    // Keep in bounds right
    if(ball.center.x > 320){
        ball.center = CGPointMake( 0, ball.center.y);
    }
    // Left 
    if(ball.center.x < 0){
        ball.center = CGPointMake( 320, ball.center.y);
    }
    // Top
    if(ball.center.y > 460){
        ball.center = CGPointMake( ball.center.x, 0);
    }
    // Bottom
    if(ball.center.y < 0){
        ball.center = CGPointMake( ball.center.x, 460);
    }
}

// Dont rotate the screen
-(BOOL)shouldAutorotate{
    return NO;
}

@end
