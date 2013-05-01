vec3 N;
vec3 V;

void main()
{
    N = normalize(gl_NormalMatrix * gl_Normal);
    V = vec3(gl_ModelViewMatrix*gl_Vertex);
    gl_TexCoord[0].xyz = reflect(V,N);

    gl_Position = ftransform(); // gl_ModelViewProjectionMatrix * gl_Vertex
}