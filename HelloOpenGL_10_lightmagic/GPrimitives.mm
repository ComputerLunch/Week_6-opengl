#import "GPrimitives.h"



#define TEX_COORD_MAX 1

MySize SizeMake(GLfloat width, GLfloat height ) {
	MySize s;
	s.width = width;
	s.height = height;
	return s;
}

Delta MakeDelta(GLfloat x, GLfloat y, GLfloat z, GLfloat rotX, GLfloat rotY, GLfloat rotZ ){
	Delta d;
	d.x = x;
	d.y = y;
	d.z = z;
    d.rotX = rotX;
    d.rotY = rotY;
    d.rotZ = rotZ;
    return d;
}

MyVector MyVectorMake(GLfloat x, GLfloat y, GLfloat z) {
	MyVector v;
	v.x = x;
	v.y = y;
	v.z = z;
	return v;
}


void spriteSetAlpha(Sprite * sprite,GLfloat alpha){
   /* 
    spritevertex[0].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[0].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[0].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[0].Color[3] = sprite.alpha;
    
    sprite.vertex[1].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[1].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[1].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[1].Color[3] = sprite.alpha;
    
    sprite.vertex[2].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[2].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[2].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[2].Color[3] = sprite.alpha;
    
    sprite.vertex[3].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[3].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[3].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[3].Color[3] = sprite.alpha;*/

   
    
    sprite->vertex[0].Color[3] = alpha;
    sprite->vertex[1].Color[3] = alpha;
    sprite->vertex[2].Color[3] = alpha;
    sprite->vertex[3].Color[3] = alpha;
}

Sprite MakeSprite(MyVector tempPos, Delta tempDelta, MySize tempSize, GLuint tempTag, GLint tempTexture, GLint tempType ){

    float depth =  0;  //1 + ((float)rand()/(float)RAND_MAX ) * 0.5;


    Sprite sprite;

    sprite.alpha = 1.0;

    sprite.tag = tempTag;
    sprite.texture = tempTexture;

    sprite.type = tempType;

    sprite.life = 300;

    sprite.xRot = 0;
    sprite.yRot = 0;
    sprite.zRot = 0;

    sprite.xScale = 1;
    sprite.yScale = 1;
    sprite.zScale = 1;

    sprite.indices[0] = 0;
    sprite.indices[1] = 1;
    sprite.indices[2] = 2;
    sprite.indices[3] = 2;
    sprite.indices[4] = 3;
    sprite.indices[5] = 0;

    sprite.width = tempSize.width;
    sprite.height = tempSize.height;

    // Set Center
    sprite.center[0] = tempPos.x;// radX;
    sprite.center[1] = tempPos.y;
    sprite.center[2] = tempPos.z;//radY;

    // Set up speed should be delta
    sprite.delta.x = tempDelta.x;
    sprite.delta.y = tempDelta.y;
    sprite.delta.z = tempDelta.z;
    sprite.delta.rotX = tempDelta.rotX;
    sprite.delta.rotY = tempDelta.rotY;
    sprite.delta.rotZ = tempDelta.rotZ;

    // Set up positions
    sprite.vertex[0].Position[0] = -1 *   sprite.width;
    sprite.vertex[0].Position[1] = -1 *  sprite.height;
    sprite.vertex[0].Position[2] = depth;

    sprite.vertex[1].Position[0] = -1 *  sprite.width;
    sprite.vertex[1].Position[1] = sprite.height;
    sprite.vertex[1].Position[2] = depth;

    sprite.vertex[2].Position[0] = sprite.width;
    sprite.vertex[2].Position[1] = sprite.height;
    sprite.vertex[2].Position[2] = depth;

    sprite.vertex[3].Position[0] = sprite.width;
    sprite.vertex[3].Position[1] = -1 * sprite.height;
    sprite.vertex[3].Position[2] = depth;

    // SET UP COLOR
    sprite.vertex[0].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[0].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[0].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[0].Color[3] = sprite.alpha;

    sprite.vertex[1].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[1].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[1].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[1].Color[3] = sprite.alpha;

    sprite.vertex[2].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[2].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[2].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[2].Color[3] = sprite.alpha;

    sprite.vertex[3].Color[0] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[3].Color[1] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[3].Color[2] = (arc4random() % 100 ) * 0.01;
    sprite.vertex[3].Color[3] = sprite.alpha;


    // TEXTURE CORD
    sprite.vertex[0].TexCoord[0] = TEX_COORD_MAX;
    sprite.vertex[0].TexCoord[1] = 0;

    sprite.vertex[1].TexCoord[0] = TEX_COORD_MAX;
    sprite.vertex[1].TexCoord[1] = TEX_COORD_MAX;

    sprite.vertex[2].TexCoord[0] = 0;
    sprite.vertex[2].TexCoord[1] = TEX_COORD_MAX;

    sprite.vertex[3].TexCoord[0] = 0;
    sprite.vertex[3].TexCoord[1] = 0;

    
    glGenBuffers(1, &sprite.vertBuff);
    glBindBuffer(GL_ARRAY_BUFFER, sprite.vertBuff);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sprite.vertex), sprite.vertex, GL_STATIC_DRAW);

    glGenBuffers(1, &sprite.indexBuff);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, sprite.indexBuff);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(sprite.indices), sprite.indices, GL_STATIC_DRAW);

    return sprite;
}

