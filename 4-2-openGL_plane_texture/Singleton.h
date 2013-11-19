#ifndef __HelloOpenGL__Singleton__
#define __HelloOpenGL__Singleton__

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <iostream>

#import "glm.hpp"
#import "matrix_transform.hpp"
#import "type_ptr.hpp"

using namespace std;

#define BUFFER_OFFSET(x)((char *)NULL+(x))
#define INX_TYPE GL_UNSIGNED_SHORT
#define TEX_COORD_MAX 1

struct vertex_struct  {
    GLfloat x,y,z;
    GLfloat r,g,b,a;
    GLfloat u,v;
};

typedef struct  {
    float faces_count;
    float vertex_count;
    GLuint texture;
    GLuint vbo;
    GLuint vinx;
}Mesh;


class Singleton
{
private:
    static bool instanceFlag;
    static Singleton *single;
    
public:
    Singleton();
    
    // OPENGL INDEXS
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _planeViewUniform;
    GLuint _texCoordSlot;
    GLuint _textureUniform;


    // TEXTURES
    GLuint t_rapping_paper;
    GLuint t_title_bg;
    GLuint t_title;
    GLuint t_particle_star;
    // MESH TEXTURES
    GLuint t_glow;
    GLuint t_cupcake;
    
    // MESH
    Mesh m_plane = { .faces_count =  2 , .vertex_count = 4 , 0,0,0 };
   

    static float RandomNumber(float Min, float Max);
    static Singleton* getInstance();

    ~Singleton()
    {
        instanceFlag = false;
    }
};


#endif
