

typedef struct
{
    GLfloat width;
    GLfloat height;
} MySize;

MySize SizeMake(GLfloat width, GLfloat height );

/** A vector in 3D space. */
typedef struct {
	GLfloat x;			/**< The X-componenent of the vector. */
	GLfloat y;			/**< The Y-componenent of the vector. */
	GLfloat z;			/**< The Z-componenent of the vector. */
} MyVector;

MyVector MyVectorMake(GLfloat x, GLfloat y, GLfloat z);

typedef struct
{
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat rotX;
    GLfloat rotY;
    GLfloat rotZ;
} Delta;

Delta MakeDelta(GLfloat x, GLfloat y, GLfloat z, GLfloat rotX, GLfloat rotY, GLfloat rotZ );

typedef struct
{
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Pnt;


typedef struct{
    float Position[3];
    float Color[4];
    float TexCoord[2]; // New
}Vertex;


typedef struct
{
    Vertex vertex[4]; 
    GLubyte indices[6];
    
    Delta delta;
    
    GLfloat center[3];
    
    GLuint texture;
    GLuint tag;
    
    GLuint vertBuff;
    GLuint indexBuff;
    
    GLint type;
    GLfloat xRot;
    GLfloat yRot;
    GLfloat zRot;
    
    GLfloat alpha;
    
    GLfloat width;
    GLfloat height;
    
    GLfloat xScale;
    GLfloat yScale;
    GLfloat zScale;
    
    GLint life;
    
} Sprite;

Sprite MakeSprite(MyVector tempPos, Delta tempDelta, MySize tempSize, GLuint tempTag, GLint tempTexture, GLint tempType );

void spriteSetAlpha(Sprite * sprite,GLfloat alpha);





