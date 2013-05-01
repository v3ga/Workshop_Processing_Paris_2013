uniform samplerCube texCubeMap;

void main()
{
	vec3 c = textureCube(texCubeMap, gl_TexCoord[0].xyz).rgb;
	gl_FragColor = vec4(c,1.0);
}