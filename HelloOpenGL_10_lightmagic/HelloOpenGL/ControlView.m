#import "ControlView.h"




@implementation ControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize winSize = self.frame.size;
        float SPACE = winSize.width/5.0;
        
       
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.5;
        
        
        NSArray * images = [[NSArray alloc]initWithObjects:
                            @"brush_1.png",
                            @"brush_2.png",
                            @"brush_3.png",
                            @"brush_4.png",
                            @"brush_5.png",
                            @"brush_6.png",
                            @"brush_7.png",
                            @"brush_8.png",
                            @"brush_9.png", nil ];
        
        
        imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, winSize.width, winSize.width/5.0)];
        imageScroll.pagingEnabled = NO;
        imageScroll.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        imageScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
       // imageScroll.alpha = 0.8;
        
        [self addSubview:imageScroll];
        
        for (int i = 0; i < [images count]; i++) {
            
            CutOutUIButton * iv = [[CutOutUIButton alloc]initWithFrame:CGRectMake(0, 0, winSize.width/7.0, winSize.width/7.0) name:[images objectAtIndex:i]];
            //iv.imageName = [images2 objectAtIndex:i];
            
            UIImage *buttonImageNormal = [UIImage imageNamed:[images objectAtIndex:i]]; 
            [iv.button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
            
        
            //iv.frame = CGRectMake(0, 0, 120, 100);
            iv.center = CGPointMake( SPACE * (i + 1), winSize.width/11.0);
            
            // if([app isFreeVersion] == 1){
            
            iv.lock.hidden = YES;
            
            [iv.button addTarget:self action:@selector(placeBackground:) forControlEvents:UIControlEventTouchUpInside]; 
            [iv.button addTarget:self action:@selector(placeBackground:) forControlEvents:UIControlEventTouchDown];    
            [iv.button addTarget:self action:@selector(placeBackground:) forControlEvents:UIControlEventTouchDragOutside];    
           
            
            //iv.layer.borderWidth = 5.0f;
            CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
            CGFloat values[4] = {1, 1, 1, 1.0}; 
            CGColorRef grey = CGColorCreate(space, values); 
            //iv.layer.borderColor = grey;
            CGColorRelease(grey);
            CGColorSpaceRelease(space);
            
            [imageScroll addSubview:iv];
        }
        
        imageScroll.contentSize = CGSizeMake(SPACE * ([images count] + 1 ), SPACE);        
    }
    return self;
}

-(void)placeBackground:(CutOutUIButton *)sender{
    CutOutUIButton * cut = (CutOutUIButton *) sender.superview;
  
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:cut.imageName] forKey:@"index"];
        
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"newSprite"
     object:self  userInfo:dict ];
}



@end
