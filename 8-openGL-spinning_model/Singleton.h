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
    GLfloat nx,ny,nz;
    GLfloat u,v;
};

typedef struct  {
    float faces_count;
    float vertex_count;
    GLuint texture;
    GLuint vbo;
    GLuint vinx;
}Mesh;

typedef struct{
    float Position[3];
    float Color[4];
    float TexCoord[2]; // New
} Vertex;




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
    GLuint t_radCube;
    GLuint t_hero;
    GLuint t_title_bg;
    GLuint t_title;
    GLuint t_particle_star;
    
    // MESH TEXTURES
    GLuint t_glow;
    GLuint t_cake;
    GLuint t_tree;
    GLuint t_hatchBack;
    GLuint t_bunny;
    
    // MESH
    Mesh m_plane = { .faces_count =  2 , .vertex_count = 4 , 0,0,0 };
    Mesh m_cupCake = { .faces_count =  84 , .vertex_count = 160 , 0,0,0 };
    Mesh m_carHatch = { .faces_count =  320 , .vertex_count = 680 , 0,0,0 };
    
    Mesh m_tree = { .faces_count =  234 , .vertex_count = 540 , 0,0,0 };
    Mesh m_bunny = { .faces_count = 434 , .vertex_count =  485 , 0,0,0 };

    void drawMesh(Mesh mesh);
    void drawMeshTexture(Mesh mesh, GLuint texture);
    
    static float RandomNumber(float Min, float Max);
    
    static Singleton* getInstance();
    void method();
    ~Singleton()
    {
        instanceFlag = false;
    }
};


#endif
