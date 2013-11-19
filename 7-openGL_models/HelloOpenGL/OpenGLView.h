#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#define FAR 10000.0f
#define NEAR 10.0f

@interface OpenGLView : UIView{
    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    UILabel * outPut; // Show FPS
    NSDate* old_date;
}

@end