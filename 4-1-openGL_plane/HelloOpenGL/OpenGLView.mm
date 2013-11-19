#import "OpenGLView.h"

#import "glm.hpp"
#import "matrix_transform.hpp"
#import "type_ptr.hpp"
#include "Singleton.h"

@implementation OpenGLView

Singleton * g;

+(Class)layerClass{
    return [CAEAGLLayer class];    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        
        g = Singleton::getInstance();   // Set up Singleton init mesh to buffer
        
        [self setupTextures];
        [self setupDisplayLink];
        
        // FPS OUTPUT
        outPut = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        [self addSubview:outPut];
    }
    return self;
}

// RENDER
//------------------------------------
-(void)render:(CADisplayLink*)displayLink {
    
    // 1. Clear buffer and set new background color
    //glEnable(GL_BLEND);
    glDisable(GL_BLEND);
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    //             r    g     b     a
    glClearColor( 0.5 ,0.5, 0.5 , 1.0); // Set Color
    glClear(  GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT  );
    
    
    // 2. Define up camera matrix "_projectionUniform"
    float ratio = self.frame.size.width / self.frame.size.height ;
    
    
    
    glm::mat4 projection;
    
    // Perspective Projection
   projection = glm::perspective(45.0f, ratio, NEAR, FAR); // <-frustum viewing pyramid
    projection = glm::translate(projection,glm::vec3(0.0f, 0.0f, -30.0f));
    glUniformMatrix4fv( g->_projectionUniform, 1, 0, glm::value_ptr(projection));
    
    
    // CAM ORTHO FLATLAND HUD
   /* projection = glm::ortho( 0.0f, self.frame.size.width, self.frame.size.height, 0.0f,-1015.0f, 1015.0f);
      projection = glm::translate(projection,glm::vec3(0.0f, 0.0f, -30.0f));
    glUniformMatrix4fv( g->_projectionUniform, 1, 0, glm::value_ptr(projection));*/

    
    // 3 Set up view port
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
   
    //------------------------------------
    // DRAW STUFF
    //------------------------------------
    
    // Aiming the gun
    glm::mat4 m = glm::mat4(1.0f);
    //m = glm::translate(m, glm::vec3(100.0,  100.0 , 0.0) );
    m = glm::scale(m , glm::vec3( 4.0f ));
    
    // ADD rotation
   /* static float k = 0;
    static float rot = 0;
    k += 0.08;
    rot = sinf(k) * 50;
    
    m = glm::rotate(m, rot, glm::vec3(0.0,  1.0 , 0.0));*/
    
    // Setting the aim
    glUniformMatrix4fv(g->_modelViewUniform, 1, 0, glm::value_ptr(m));
    
    // Firing gun
    drawMeshTexture(g->m_plane, g->t_rapping_paper);
    
  
    // 5. Present Renderbuffer to be displayed on screen
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    
    // DRAW FPS
    NSDate* new_date = [NSDate date];
    double freq = 1.0 / [new_date timeIntervalSinceDate: old_date];
    [old_date release];
    old_date = [new_date retain];
    outPut.text = [NSString stringWithFormat:@"FPS:%0.0f", freq ];
}

// Main draw mesh
// Glow Print - Dark Background // glBlendFunc(GL_SRC_COLOR, GL_ONE);
// Glow Print white edge - Dark Background //glBlendFunc(GL_SRC_ALPHA, GL_ONE);
// Glow Print color burn white edge changes colors - Dark Background // glBlendFunc(GL_ONE, GL_ONE);
void drawMeshTexture(Mesh mesh, GLuint texture){
    
    glBindBuffer(GL_ARRAY_BUFFER, mesh.vbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mesh.vinx);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(g->_textureUniform, 0);
    
    glVertexAttribPointer(g->_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(struct vertex_struct), BUFFER_OFFSET( 0 ));
    glVertexAttribPointer(g->_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(struct vertex_struct), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(g->_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(struct vertex_struct), BUFFER_OFFSET( (sizeof(float) * 7)));
    
    glDrawElements(GL_TRIANGLES, mesh.faces_count * 3, INX_TYPE, 0);
}



// SETUP function
//--------------------------------
-(void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

-(void)setupContext{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    if(![EAGLContext setCurrentContext:_context]){
        
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

-(void)setupRenderBuffer{
    glGenRenderbuffers(1, &Singleton::getInstance()->_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, Singleton::getInstance()->_colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

-(void)setupFrameBuffer{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER , Singleton::getInstance()->_colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, Singleton::getInstance()->_depthRenderBuffer);
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &Singleton::getInstance()->_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, Singleton::getInstance()->_depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);    
}

// Compile Shaders function
//--------------------------------
-(GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType{
    
    // 1 - NSString with the contents of the file. 
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    
    if(!shaderString){
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2 - create a OpenGL object to represent the shader.
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStrignUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStrignUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@" %@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

-( void )compileShaders {
    
    // 1 get uniqe shader number
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" withType:GL_FRAGMENT_SHADER];
    
    //- 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    //- 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@" %@", messageString );
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    Singleton::getInstance()->_positionSlot = glGetAttribLocation( programHandle , "Position" );
    Singleton::getInstance()->_colorSlot = glGetAttribLocation(programHandle ,  "SourceColor" );
    glEnableVertexAttribArray( Singleton::getInstance()->_positionSlot );
    glEnableVertexAttribArray( Singleton::getInstance()->_colorSlot );
    
    Singleton::getInstance()->_projectionUniform = glGetUniformLocation(programHandle, "Projection");
    Singleton::getInstance()->_modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    Singleton::getInstance()->_planeViewUniform = glGetUniformLocation(programHandle, "Planeview");
    
    
    Singleton::getInstance()->_texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(Singleton::getInstance()->_texCoordSlot);
    Singleton::getInstance()->_textureUniform = glGetUniformLocation(programHandle, "Texture");
}

-(void)setupDisplayLink{

    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

// Handle import texture
- (GLuint)setupTexture:(NSString *)fileName {    
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2 -
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, 
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);  
    // 3 -
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}

-(void)setupTextures{ 
    
    g->t_rapping_paper = [self setupTexture:@"rapping_paper.png"];  // GOOD GUY
    g->t_title_bg = [self setupTexture:@"title_bg.png"];
    g->t_title = [self setupTexture:@"title.png"];
    g->t_particle_star = [self setupTexture:@"star.png"];

    // Model textures
    g->t_glow = [self setupTexture:@"glow.png"];
    g->m_plane.texture =  g->t_particle_star;
    
}

@end