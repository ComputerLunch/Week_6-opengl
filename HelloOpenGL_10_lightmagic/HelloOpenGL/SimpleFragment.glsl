varying lowp vec4 DestinationColor; // 1

varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void){
 gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New

 ///  gl_FragColor = DestinationColor; // 3

// This discard any pixel that has alpha of 0.0
//if(gl_FragColor.w == 0.0)
  // discard;
    
    
//gl_FragColor =  DestinationColor * gl_FragColor;

}