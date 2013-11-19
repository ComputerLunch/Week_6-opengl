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
    {-1.0f, -1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, TEX_COORD_MAX, 0.0f},
    {-1.0f,  1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, TEX_COORD_MAX,TEX_COORD_MAX},
    { 1.0f,  1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f,TEX_COORD_MAX},
    { 1.0f, -1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f,0.0f},
};
unsigned short m_plane_indexes[]={ 0,1,2,2,3,0 };


//------------------------------------------------
// Cube: Basic Cube
//------------------------------------------------
struct vertex_struct m_cube_vertices[] = {
    /* CUBE: 24 vertices */
	{-1.0f,  1.0f,  -1.0f, -1.0f, 0.0f, -0.0f, 0.0f, TEX_COORD_MAX, 0.0f},
	{-1.0f, -1.0f, -1.0f, -1.0f, 0.0f, -0.0f, 0.0f,  TEX_COORD_MAX,TEX_COORD_MAX},
	{-1.0f, -1.0f,  1.0f, -1.0f, 0.0f, -0.0f, 0.0f, 0.0f, TEX_COORD_MAX},
	{-1.0f,  1.0f,  1.0f, -1.0f, 0.0f, -0.0f, 0.0f, 0.0f, 0.0f},
    
	{-1.0f, 1.0f, 1.0f, 0.0f, 1.0f, -0.0f, 0.0f, TEX_COORD_MAX, 0.0f},
	{1.0f,  1.0f, 1.0f, 0.0f, 1.0f, -0.0f, 0.0f, TEX_COORD_MAX,TEX_COORD_MAX},
	{1.0f,  1.0f, -1.0f, 0.0f, 1.0f, -0.0f, 0.0f, 0.0f, TEX_COORD_MAX},
	{-1.0f, 1.0f, -1.0f, 0.0f, 1.0f, -0.0f, 0.0f, 0.0f, 0.0f},
    
	{1.0f,  1.0f, 1.0f, 1.0f, 0.0f, -0.0f, 0.0f, TEX_COORD_MAX, 0.0f},
	{1.0f, -1.0f,  1.0f, 1.0f, 0.0f, -0.0f, 0.0f, TEX_COORD_MAX,TEX_COORD_MAX},
	{1.0f, -1.0f, -1.0f, 1.0f, 0.0f, -0.0f, 0.0f, 0.0f, TEX_COORD_MAX},
	{1.0f,  1.0f,  -1.0f, 1.0f, 0.0f, -0.0f, 0.0f, 0.0f, 0.0f},
    
    
	{-1.0f, -1.0f, -1.0f, 0.0f, -1.0f, -0.0f, 0.0f, TEX_COORD_MAX, 0.0f},    
	{1.0f,  -1.0f, -1.0f, 0.0f, -1.0f, -0.0f, 0.0f, TEX_COORD_MAX,TEX_COORD_MAX},
	{1.0f, -1.0f,  1.0f, 0.0f, -1.0f, -0.0f, 0.0f, 0.0f, TEX_COORD_MAX},
	{-1.0f, -1.0f, 1.0f, 0.0f, -1.0f, -0.0f, 0.0f, 0.0f},
	
    {-1.0f, -1.0f, -1.0f, -0.0f, 0.0f, -1.0f, 0.0f, TEX_COORD_MAX, 0.0f},
	{-1.0f,  1.0f, -1.0f, -0.0f, 0.0f, -1.0f, 0.0f, TEX_COORD_MAX,TEX_COORD_MAX},
	{1.0f,  1.0f, -1.0f, -0.0f, 0.0f, -1.0f, 0.0f, 0.0f, TEX_COORD_MAX},
	{1.0f, -1.0f, -1.0f, -0.0f, 0.0f, -1.0f, 0.0f, 0.0f, 0.0f},
	
    {1.0f, -1.0f, 1.0f, -0.0f, 0.0f,  1.0f, 0.0f, TEX_COORD_MAX, 0.0f},
	{1.0f,  1.0f, 1.0f, -0.0f, 0.0f,  1.0f, 0.0f, TEX_COORD_MAX,TEX_COORD_MAX},
	{-1.0f, 1.0f, 1.0f, -0.0f, 0.0f,  1.0f, 0.0f, 0.0f, TEX_COORD_MAX},
	{-1.0f, -1.0f, 1.0f, -0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f},
};


unsigned short m_cube_indexes[]={
    /* CUBE 12 faces */
    0, 1, 2, 0, 2, 3, 4, 5, 6, 4, 6, 7, 8, 9, 10, 8, 10, 11, 12, 13, 14, 12, 14, 15, 16, 17, 18, 16, 18, 19, 20, 21, 22, 20, 22, 23,
};



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
    
    // CUBE
    glGenBuffers(1,  &m_cube.vbo);
    glBindBuffer(GL_ARRAY_BUFFER, m_cube.vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof (struct vertex_struct) * m_cube.vertex_count , m_cube_vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &m_cube.vinx);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_cube.vinx);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof (m_cube_indexes[0])* m_cube.faces_count * 3 , m_cube_indexes, GL_STATIC_DRAW);
        
}
