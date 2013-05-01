/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Applying a 2D filter on top off a 3D renderer scene with lights
 —
 GLGraphics 1.0.0

*/

// --------------------------------------------------------
import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;


// --------------------------------------------------------
TorusKnot torusKnot;
GLModel modelMesh;
GLGraphicsOffScreen offscreen;
GLSLShader shaderDither;

// --------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);
  torusKnot = new TorusKnot(120,4,10);
  modelMesh = convertGLModel(torusKnot.mesh);
  offscreen = new GLGraphicsOffScreen(this, width, height);
  shaderDither = new GLSLShader(this, "dither_vert.glsl", "dither_frag.glsl");
}

// --------------------------------------------------------
void draw()
{
  offscreen.beginDraw();
  offscreen.background(0);

  offscreen.beginGL();
  offscreen.pointLight(0, 0, 200, mouseX, mouseY, 0);  
  offscreen.pointLight(200, 0, 0, mouseX, mouseY, 400);  
  offscreen.translate(offscreen.width/2, offscreen.height/2,100);
  offscreen.rotateX( radians(frameCount/2)/*radians(50)*/ );
  offscreen.rotateY( radians(frameCount/2)/*radians(50)*/ );
  offscreen.model(modelMesh);
  offscreen.endGL();
  offscreen.endDraw();


  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  shaderDither.start(); // Enabling shader.
  shaderDither.setFloatUniform("scale", 1.0);
  shaderDither.setTexUniform("texture", offscreen.getTexture());
  

  beginShape(QUADS);
  textureMode(NORMALIZED);
  texture(offscreen.getTexture());
  vertex(0, 0, 0, 0);
  vertex(2*width, 0, 1, 0); // why 2 ????
  vertex(2*width, 2*height, 1, 1); 
  vertex(0, 2*height, 0, 1);  
  endShape();
  
  shaderDither.stop();
  renderer.endGL();

}

// ----------------------------------------------------------------
GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  int nbVertices = vertices.length/4;

  float[] normals=mesh.getVertexNormalsAsArray();
  
  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);
  
  m.beginUpdateVertices();
    for (int i = 0; i < nbVertices; i++) m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  m.endUpdateVertices(); 
  
  m.initNormals();
  m.beginUpdateNormals();
  for (int i = 0; i < nbVertices; i++) m.updateNormal(i, normals[4 * i], normals[4 * i + 1], normals[4 * i + 2]);
  m.endUpdateNormals();  

  return m;
}

// ----------------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    saveFrame("export.png");
}
