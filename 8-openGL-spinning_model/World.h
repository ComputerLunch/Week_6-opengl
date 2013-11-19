#ifndef __HelloOpenGL__World__
#define __HelloOpenGL__World__

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <iostream>
#include <vector>

using namespace std;


#include "Singleton.h"
//#include "Emitter.h"
//#include "RenderMesh.h"
#include "Item.h"



class World{


    
public:
    void init();
    void step();
    void draw();
    

    
private:
    //RenderMesh r;
    Singleton * a;
    glm::mat4 m;

    vector<Item>items;
    
    void newItem();
};

#endif 
