#import "OpenGLView.h"
#include <vector>
#include <iostream>

using namespace std;

extern "C"
{
#include "CC3GLMatrix.h"
    // ... Other freetype includes
}

@implementation OpenGLView


+(Class)layerClass{
    return [CAEAGLLayer class];    
}


vector<Sprite>s;


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
        [self setupTextures];
        [self setupWorld];
        
        [self setupDisplayLink];
        [self setupControls];
        
        
        self.multipleTouchEnabled = YES;
        
        //sprites = [[NSMutableArray alloc]init];
        
        regMark = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        regMark.backgroundColor = [UIColor redColor];
        //[self addSubview:regMark];
                   
        // init first texture
        GLuint rad = random() % (_totalTextures );
        _currentTexture = _textures[rad];
        
        //spawnTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(spawnSprite) userInfo:nil repeats:YES];
        
    }
    return self;
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
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

-(void)setupFrameBuffer{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER , _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
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
    _positionSlot = glGetAttribLocation( programHandle , "Position" );
    _colorSlot = glGetAttribLocation(programHandle ,  "SourceColor" );
    glEnableVertexAttribArray( _positionSlot );
    glEnableVertexAttribArray( _colorSlot );
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    _planeViewUniform = glGetUniformLocation(programHandle, "Planeview");
    
    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
}

// RENDER
//------------------------------------
-(void)render:(CADisplayLink*)displayLink {
    
    // Make black pngs transparent screen effect
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    //glBlendFunc(GL_SRC_COLOR, GL_ONE);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glBlendFunc (GL_ONE, GL_ONE); //screen
   // glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    
    
    if (blankScreen) {
        //glClearColor( 0.0 , 0.0, 0.0 , 0.1); // GRAy
        glClear( GL_DEPTH_BUFFER_BIT );
    }else{
         glClearColor( 0.0 , 0.0, 0.0 , 1.0); // RED
         glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    }
    
    
    
    // projection or camera
    CC3GLMatrix * projection = [CC3GLMatrix matrix];
    float h = 4.0f * self.frame.size.height / self.frame.size.width ;
    //[projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:NEAR andFar:FAR];
    
    [projection populateOrthoFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:NEAR andFar:FAR];
    
   
    [projection translateBy:CC3VectorMake(0, 0, 0)];
    /*
    [projection translateBy:CC3VectorMake(-4, touchDelta[1], touchDelta[0])];
    [projection rotateBy:CC3VectorMake(lookDelta[1], lookDelta[0], 0 )];
    */
     
    //[projection rotateBy:CC3VectorMake(0, 0, 90)];
    
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    // Set model matrix
    CC3GLMatrix * modelView = [CC3GLMatrix matrix];
  
    // 1 Set up view port
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    
   // printf("%li ", s.size());
    
    for (int i = 0 ; i < s.size() ; i ++) {
        
        GLfloat alpha = s[i].life / 100.0;
        
        //cout << " " << alpha;
        spriteSetAlpha(&s[i], alpha );
        
        
        
        s[i].center[0] =  s[i].center[0] + s[i].delta.x;
        s[i].center[1] =  s[i].center[1] + s[i].delta.y;
        s[i].center[2] =  s[i].center[2] + s[i].delta.z;
        s[i].xRot =  s[i].xRot + s[i].delta.rotX;
        s[i].yRot =  s[i].yRot + s[i].delta.rotY;
        s[i].zRot =  s[i].zRot + s[i].delta.rotZ;        
        
        // Reset matrixs
        [modelView populateFromTranslation:CC3VectorMake(0,0,0)];
        [modelView scaleBy:CC3VectorMake(s[i].xScale, s[i].xScale, 1)];
        [modelView translateBy:CC3VectorMake(s[i].center[0], s[i].center[1], s[i].center[2])];
        [modelView rotateBy:CC3VectorMake( s[i].xRot,  s[i].yRot, s[i].zRot )];
  

    
        // Erase and remove item
        if( s[i].life < 0){
            
            //delete &s[i];
            
            //Sprite * temp = &s[i];
            
            
            glDeleteBuffers(1, &s[i].vertBuff);
            glDeleteBuffers(1, &s[i].indexBuff);
            
            s.erase(s.begin()+i);
            
           // delete temp;
            
            
        }else {
            s[i].life --;
            
            glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
            
            // BLEND MODES
            glEnable(GL_BLEND);
            //glBlendFunc(GL_ONE , GL_ONE_MINUS_SRC_ALPHA );
              glBlendFunc(GL_SRC_COLOR, GL_ONE);

            // update vertex buffers    
            glBindBuffer(GL_ARRAY_BUFFER, s[i].vertBuff);
            glBufferData(GL_ARRAY_BUFFER, sizeof(s[0].vertex), s[i].vertex, GL_STATIC_DRAW);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, s[i].indexBuff);
            
            glActiveTexture(GL_TEXTURE0); 
            glBindTexture(GL_TEXTURE_2D, s[i].texture);
            glUniform1i(_textureUniform, 0);  
            
            glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
            glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
            glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
            
            // This should be the same number of indices - need to link to real indices later
            glDrawElements(GL_TRIANGLE_FAN, sizeof(s[i].indices)/sizeof(s[i].indices[0]), GL_UNSIGNED_BYTE, 0);
        }
    }
    

    [_context presentRenderbuffer:GL_RENDERBUFFER];
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
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}






-(void)setupWorld{
    
    pp.x = 0;
    pp.y = 0;
    tp.x = 0;
    tp.y = 0;
    numItems = 0;
    currentItem = 0;
    _zSpeed = -0.02;
    
}

-(void)setupTextures{ 
    
    
    _totalTextures = 9;
    _textures[0] = [self setupTexture:@"brush_1.png"];
    _textures[1] = [self setupTexture:@"brush_2.png"];
    _textures[2] = [self setupTexture:@"brush_3.png"];
    _textures[3] = [self setupTexture:@"brush_4.png"];
    _textures[4] = [self setupTexture:@"brush_5.png"];
    _textures[5] = [self setupTexture:@"brush_6.png"];
    _textures[6] = [self setupTexture:@"brush_7.png"];
    _textures[7] = [self setupTexture:@"brush_8.png"];
    _textures[8] = [self setupTexture:@"brush_9.png"];

   
}


-(void)setupControls{
    controls = [[ControlView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    [self addSubview:controls];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(randomBrush:)
     name:@"newSprite"
     object:nil ];
}

-(void)mode1{ mode = MODE_BOMB; }
-(void)mode2{ mode = MODE_FLOWER; }

-(void)btnShow{
    if(controls.hidden == YES){
        controls.hidden = NO;
    }else {
        controls.hidden = YES;
    }
}

-(void)randomBrush:(NSNotification *) notification{
    
   // NSDictionary * dict = [notification userInfo];
    
    //[dict objectForKey:@"index"];
    
    
    NSString * tempStr =  [notification.userInfo objectForKey:@"index"];

    //CFShow([dict );
    
   // GLuint rad = random() % (_totalTextures );
   // _currentTexture = _textures[rad];
   _currentTexture = [self setupTexture:tempStr];
}

-(void)newBG{
    
}

-(void)spawnSprite{
    
   // [spawnTimer invalidate];
    
    GLfloat delay =  touchDelta[0] / 200;
    
    if(delay < 0.1){
        delay = 0.1;
    }
    
    // get random texture every time
    GLuint rad = random() % (_totalTextures );
    _currentTexture = _textures[rad];

    
  //  spawnTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(spawnSprite) userInfo:nil repeats:YES];

    
    GLfloat xSet = ((float)rand()/(float)RAND_MAX * RANGE_X) - RANGE_X/8.0;
    GLfloat ySet = ((float)rand()/(float)RAND_MAX * RANGE_Y) - RANGE_Y/8.0;
 
    
    s.push_back( MakeSprite(MyVectorMake(xSet, ySet, -4), 
                            MakeDelta(0.0, 0, 0, 0, 0, 0), 
                            SizeMake(0.2, 0.2), 
                            currentItem, 
                            _currentTexture, 
                            TYPE_BACKGROUND)); 
                
    //cout << s.size() << " ";  
}

-(void)spawnSpriteOnTouch:(CGPoint)pnt{
    
    regMark.center = pnt;
    pnt.x = 2 * (( pnt.x / (self.frame.size.width * 0.5) ) - 1);
    pnt.y =  -2.65* (( pnt.y / (self.frame.size.height * 0.5) ) - 1);
    
    
   // printf("- %2.2f,%2.2f", pnt.x, pnt.y);
    
    
    float xVar =  RandomDoubleBetween(-0.02, 0.02);
    float yVar =  RandomDoubleBetween(-0.02, 0.02);
    float scaleVar =  RandomDoubleBetween(0.05, 0.3);
    float rotVar =  RandomDoubleBetween(-15.5, 15.5);
    
    s.push_back( MakeSprite(MyVectorMake(pnt.x, pnt.y, -0.1), 
                            MakeDelta(xVar, yVar, -0.01, 0, 0, rotVar), 
                            SizeMake(scaleVar, scaleVar), 
                            currentItem, 
                            _currentTexture, 
                            TYPE_BACKGROUND)); 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    
    CGPoint pnt = [touch locationInView:self];
    
    UITouch *touch2;
    UITouch *touch3; 
    UITouch *touch4; 
    UITouch *touch5; 
    
    GLuint touchCount = [touches count];
    if ( touchCount == 5) {
        touch5 = [[touches allObjects] objectAtIndex:4];
        CGPoint pnt5 = [touch5 locationInView:self];
        touch4 = [[touches allObjects] objectAtIndex:3];
        CGPoint pnt4 = [touch4 locationInView:self];
        touch3 = [[touches allObjects] objectAtIndex:2];
        CGPoint pnt3 = [touch3 locationInView:self];
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt5];
        [self spawnSpriteOnTouch:pnt4];
        [self spawnSpriteOnTouch:pnt3];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt];  
    } else if ( touchCount == 4) {
        touch4 = [[touches allObjects] objectAtIndex:3];
        CGPoint pnt4 = [touch4 locationInView:self];
        touch3 = [[touches allObjects] objectAtIndex:2];
        CGPoint pnt3 = [touch3 locationInView:self];
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt4];
        [self spawnSpriteOnTouch:pnt3];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt];  
    }else if ( touchCount == 3) {
        touch3 = [[touches allObjects] objectAtIndex:2];
        CGPoint pnt3 = [touch3 locationInView:self];
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt3];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt]; 
    } else if(touchCount == 2){
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt];
    } else {
        [self spawnSpriteOnTouch:pnt];
    }

    
    pp.x = pnt.x; 
    pp.y = pnt.y;   
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    CGPoint pnt = [touch locationInView:self];
    UITouch *touch2; 
    UITouch *touch3;
    UITouch *touch4;
    UITouch *touch5; 

    GLuint touchCount = [touches count];
    if ( touchCount == 5) {
        touch5 = [[touches allObjects] objectAtIndex:4];
        CGPoint pnt5 = [touch5 locationInView:self];
        touch4 = [[touches allObjects] objectAtIndex:3];
        CGPoint pnt4 = [touch4 locationInView:self];
        touch3 = [[touches allObjects] objectAtIndex:2];
        CGPoint pnt3 = [touch3 locationInView:self];
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt5];
        [self spawnSpriteOnTouch:pnt4];
        [self spawnSpriteOnTouch:pnt3];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt];  
    } else if ( touchCount == 4) {
        touch4 = [[touches allObjects] objectAtIndex:3];
        CGPoint pnt4 = [touch4 locationInView:self];
        touch3 = [[touches allObjects] objectAtIndex:2];
        CGPoint pnt3 = [touch3 locationInView:self];
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt4];
        [self spawnSpriteOnTouch:pnt3];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt];  
    }else if ( touchCount == 3) {
        touch3 = [[touches allObjects] objectAtIndex:2];
        CGPoint pnt3 = [touch3 locationInView:self];
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt3];
        [self spawnSpriteOnTouch:pnt2];
        [self spawnSpriteOnTouch:pnt]; 
    } else if(touchCount == 2){
        touch2 = [[touches allObjects] objectAtIndex:1];
        CGPoint pnt2 = [touch2 locationInView:self];
        [self spawnSpriteOnTouch:pnt2];
         [self spawnSpriteOnTouch:pnt];
    } else {
        [self spawnSpriteOnTouch:pnt];
    }
    
    pp = tp;
}

@end
