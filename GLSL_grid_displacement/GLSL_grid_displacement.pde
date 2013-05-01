/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Applying a displacement texture to a grid (created from Toxi Terrain model)
 —
 GLGraphics 1.0.0

*/
// ----------------------------------------------------------------
import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

// ----------------------------------------------------------------
// Model stored on GPU side
Terrain grid;
GLModel modelPlane;
GLTexture texDisplacement;
GLSLShader shader;

// ----------------------------------------------------------------
void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);
  texDisplacement = new GLTexture(this, "milan.jpg");
  grid = new Terrain(100,100,5);

  modelPlane = convertGLModel( (TriangleMesh) grid.toMesh() );
  modelPlane.initTextures(1);
  modelPlane.setTexture(0,texDisplacement);

  shader = new GLSLShader(this, "displacement_vert.glsl", "displacement_frag.glsl");
}

// ----------------------------------------------------------------
void draw()
{
  background(0);
  translate(width/2, height/2,0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_LINE );
  
  shader.start();
  shader.setTexUniform("texDisplacement", texDisplacement);
  shader.setFloatUniform("gridSize", 500);
  fill(255);
  renderer.model(modelPlane);
 shader.stop();
  
  // back to processing
  renderer.endGL();
}

// ----------------------------------------------------------------
GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  int nbVertices = vertices.length/4;
  
  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);
  
  m.beginUpdateVertices();
    for (int i = 0; i < nbVertices; i++) m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  m.endUpdateVertices(); 

  return m;
}

// ----------------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    saveFrame("export.png");
}



