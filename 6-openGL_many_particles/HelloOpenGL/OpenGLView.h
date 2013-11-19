#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#define FAR 100.0f
#define NEAR 10.0f

#define LEFT_BOUND 10.5
#define RIGHT_BOUND -10.5
#define TOP_BOUND 12.5
#define BOT_BOUND -12.5

@interface OpenGLView : UIView{
    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    UILabel * outPut; // Show FPS
    NSDate* old_date;
}

@end