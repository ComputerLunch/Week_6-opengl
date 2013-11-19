#include "World.h"

#define LEFT_BOUND 10.5
#define RIGHT_BOUND -10.5
#define TOP_BOUND 12.5
#define BOT_BOUND -12.5

void World::init(){
    
    a = Singleton::getInstance();
    
    // init render engine
   // r.init();
    
    for (int i = 0; i < 20; i ++){
        newItem();
    }
}

void World::step(){

    int totalItems = items.size();
    for (int i = 0; i < totalItems; i ++){
    
        Item * t = &items[i];
        
        t->x = t->x + t->dx;
        t->y = t->y + t->dy;
        t->z = t->z + t->dz;
        
        // Detect bounds
        if (t->x >  LEFT_BOUND - 1.3 ) {
            t->dx = t->dx * -1;
        }
        if (t->x < RIGHT_BOUND + 1.3) {
           t->dx = t->dx * -1;
        }
        if (t->y >  TOP_BOUND -1.3) {
            t->dy = t->dy * -1;
        }
        if (t->y < BOT_BOUND + 1.3) {
            t->dy = t->dy * -1;
        }
    }
}

static float k = 0;

void World::draw(){
   
    glEnable(GL_DEPTH_TEST);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    
    k = k + 0.1;
    //cout << items.size();
    
    int totalItems = items.size();
    for (int i = 0; i < totalItems; i ++){
        
        m = glm::mat4(1.0f);
        m = glm::translate(m, glm::vec3(items[i].x,items[i].y ,items[i].z) );
        m = glm::scale(m , glm::vec3(1.0f));
        m = glm::rotate(m, k, glm::vec3(0.0f, k, 0.0f));
        
        glUniformMatrix4fv(a->_modelViewUniform, 1, 0, glm::value_ptr(m));
        
      //  r.drawMesh(a->m_cake);
    }
}

void World::newItem(){
    
    Item temp;// = Item::Item();
    temp.x = Singleton::RandomNumber(-0.2, 0.2);
    temp.y = Singleton::RandomNumber(-0.2, 0.2);
    
    temp.dx = 0.1; // Singleton::RandomNumber(0.1, -0.1);
    temp.dy = Singleton::RandomNumber(0.1, -0.1);
    
    items.push_back( temp ) ;
}