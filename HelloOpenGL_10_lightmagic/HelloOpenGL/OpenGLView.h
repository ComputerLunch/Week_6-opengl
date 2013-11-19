#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ControlView.h"


#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "GPrimitives.h"

#define MAXSPEED 0.05
#define RANGE_X 0.2
#define RANGE_Y 0.2



#define FAR 2
#define NEAR 0

#define SPRITE_WIDTH 6
#define SPRITE_HEIGHT 6

#define MODE_BOMB 1
#define MODE_FLOWER 1

#define TYPE_BACKGROUND -1
#define TYPE_BOMB 2


@interface OpenGLView : UIView{
    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
  
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _planeViewUniform;
    
    NSTimer * spawnTimer;
    
    //NSMutableArray * sprites;
    
    float _currentRotation;
    
    
    float _rot;
    float _zSpeed;
    BOOL blankScreen;
    GLint mode;
  
    GLuint _texCoordSlot;
    GLuint _textureUniform;
    
    GLuint _textures[50];    // Hold texture ints
    GLuint _bgTextures[50]; 
    
    
    GLuint _currentTexture;
    GLuint _totalTextures;
    GLuint _totalBG;

    UIView * regMark;
    
    GLuint numItems;
    GLuint currentItem;
    
    // Touch
    Pnt tp;
    Pnt pp;
    GLfloat touchDelta[2];
    GLfloat lookDelta[2];
   
    ControlView * controls;
    
}

@end