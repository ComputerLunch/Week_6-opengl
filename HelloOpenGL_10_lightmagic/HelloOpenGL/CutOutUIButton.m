#import "CutOutUIButton.h"

@implementation CutOutUIButton

@synthesize imageName, button, lock;

- (id)initWithFrame:(CGRect)frame name:(NSString *)tempName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageName = tempName;
        
        //self.backgroundColor = [UIColor redColor];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.frame = frame;        
        [self addSubview:button];
        
        lock = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lock.png"]];
        lock.frame = CGRectMake(20, 15, frame.size.width/2, frame.size.width/2);
        [self addSubview:lock];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    // Drawing code
}



@end
