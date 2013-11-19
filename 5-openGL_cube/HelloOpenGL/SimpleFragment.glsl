varying lowp vec4 DestinationColor;
varying lowp vec2 TexCoordOut; 
uniform sampler2D Texture; 

void main(void){
   
  // gl_FragColor = texture2D(Texture, TexCoordOut); // Only render based on texture

  // gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // render based on texture and vertex color

   gl_FragColor = DestinationColor; // Only display color base vertex color
}