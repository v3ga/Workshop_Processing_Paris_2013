uniform sampler2D texDisplacement;
uniform float amplitude;

void main() 
{
  // v.y = v.y+50.0*length( texture2D( texDisplacement, uv.st ).rgb ); 
  	vec4 uv = gl_MultiTexCoord0;
	float d = length( texture2D( texDisplacement, uv.st ).rgb );

	vec3 n = normalize(gl_Normal);
	vec3 v = gl_Vertex.xyz + amplitude*d*n;

	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1);
}

