#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <iostream>

class Item{

private:
   
    
public:
    

    GLfloat dx;
    GLfloat dy;
    GLfloat dz;
    GLfloat dRoll;
    GLfloat dPan;
    GLfloat dTilt;
    
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat roll;
    GLfloat pan;
    GLfloat tilt;
    
    GLuint texture;
    GLuint tag;
     
    GLfloat xScale;
    GLfloat yScale;
    GLfloat zScale;
    
    GLint life;
    
    GLboolean shouldRemove;
    
    Item(){
        
        x = 0;
        y = 0;
        z = 0;
    
        life = 0;
        shouldRemove = false;
        tag = 0;
        texture = 0;
        
        roll = 0;
        pan = 0;
        tilt = 0;
        
        xScale = 1;
        yScale = 1;
        zScale = 1;
    
        dx = 0;
        dy = 0;
        dz = 0;
        dRoll = 0;
        dPan = 0;
        dTilt = 0;
    }
};
