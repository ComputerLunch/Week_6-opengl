#include "Singleton.h"

bool Singleton::instanceFlag = false;
Singleton* Singleton::single = NULL;
Singleton* Singleton::getInstance()
{
    if(! instanceFlag)
    {
        single = new Singleton();
        instanceFlag = true;
        return single;
    }
    else
    {
        return single;
    }
}

float Singleton::RandomNumber(float Min, float Max)
{
    return ((float(rand()) / float(RAND_MAX)) * (Max - Min)) + Min;
}

//------------------------------------------------
// Plane: Simple plane
//------------------------------------------------
struct vertex_struct m_plane_vertices[] = {
    // x     y       z    r    g    b        u     v
    {-1.0f, -1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, TEX_COORD_MAX, 0.0f},
    {-1.0f,  1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, TEX_COORD_MAX,TEX_COORD_MAX},
    { 1.0f,  1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,TEX_COORD_MAX},
    { 1.0f, -1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f,0.0f},
};
unsigned short m_plane_indexes[]={ 0,1,2,2,3,0 };




Singleton::Singleton()
{
    //private constructor
    
    // PLANE
    glGenBuffers(1,  &m_plane.vbo);
    glBindBuffer(GL_ARRAY_BUFFER, m_plane.vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof (struct vertex_struct) * m_plane.vertex_count , m_plane_vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &m_plane.vinx);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_plane.vinx);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof (m_plane_indexes[0])* m_plane.faces_count * 3 , m_plane_indexes, GL_STATIC_DRAW);
        
}
