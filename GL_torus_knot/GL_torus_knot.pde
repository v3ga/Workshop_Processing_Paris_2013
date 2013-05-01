/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 TorusKnot with GLModel
 —
 GLGraphics 1.0.0

*/


// ----------------------------------------------------------------
import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.*;
import toxi.geom.mesh.*;

GLModel modelMesh;
boolean isFilled = true;

// ----------------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);
  modelMesh = convertGLModel(new TorusKnot(120,2,5).mesh);
}

// ----------------------------------------------------------------
void draw()
{
  background(0);

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();


  translate(width/2, height/2);
  rotateX( map(mouseY,0,height,-PI,PI) );
  rotateY( map(mouseX,0,width,-PI,PI) );


  pointLight(51, 102, 126, 0, 0, 200);  
  modelMesh.render();
  
  renderer.endGL();
}

// ----------------------------------------------------------------
GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  float[] normals=mesh.getVertexNormalsAsArray();
  int nbVertices = vertices.length/4;
  
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
    isFilled =!isFilled;
}
