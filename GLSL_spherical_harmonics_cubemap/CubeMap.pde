// --------------------------------------------------------
class CubeMap
{
  int[] glTextureId = {0};
  String[] textureNames = {"+x.jpg", "-x.jpg", "+y.jpg", "-y.jpg", "+z.jpg", "-z.jpg"};
  GLTexture[] textures;
    
  void initGL(PApplet applet, GL gl, String cubemapName)
  {
    textures = new GLTexture[6];
    for (int i = 0; i < 6; i++) 
    {
        GLTexture tex = new GLTexture(applet, "cubemaps/"+cubemapName+"/"+textureNames[i]);
        textures[i] = tex;
    }
  
    gl.glGenTextures(1, glTextureId, 0);
    gl.glBindTexture(GL.GL_TEXTURE_CUBE_MAP, glTextureId[0]);
    gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
    gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
    gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_R, GL.GL_CLAMP_TO_EDGE);
    gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
    gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);

    for (int i = 0; i < 6; i++) 
    {
        GLTexture tex = textures[i];
        int[] pix = new int[tex.width * tex.height];
        tex.getBuffer(pix, ARGB, GLConstants.TEX_BYTE);
        gl.glTexImage2D(GL.GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, GL.GL_RGBA, tex.width, tex.height, 0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, IntBuffer.wrap(pix));
    }

    
  }
  
}
