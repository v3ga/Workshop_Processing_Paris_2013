uniform sampler2D texDisplacement;
uniform float gridSize;

void main() 
{
  vec4 v = gl_Vertex;
  vec4 uv = vec4( (v.x+250.0)/gridSize, (v.z+250.0)/gridSize, 0.0, 0.0);
  v.y = v.y+50.0*length( texture2D( texDisplacement, uv.st ).rgb ); 

	gl_TexCoord[0] = uv;
   gl_Position = gl_ModelViewProjectionMatrix * v;
}

