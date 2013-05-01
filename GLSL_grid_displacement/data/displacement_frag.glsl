uniform sampler2D texDisplacement;
void main() 
{
//  gl_FragColor = gl_Color;
//  gl_FragColor = vec4(0.0,1.0,0.0,1.0);
  gl_FragColor = texture2D(texDisplacement, gl_TexCoord[0].st);
}


