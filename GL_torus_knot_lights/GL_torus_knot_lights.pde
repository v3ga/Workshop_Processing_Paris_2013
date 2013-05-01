/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Point lights applied to a GLModel
 —
 GLGraphics + GSVideo

*/

// --------------------------------------------------------
import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;


// --------------------------------------------------------
GLModel modelMesh;

// --------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);
  modelMesh = convertGLModel(new TorusKnot(120,2,10).mesh);
}

// --------------------------------------------------------
void draw()
{
  background(0);


  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();

  pointLight(0, 0, 200, 0, 0, 0);  
  pointLight(200, 0, 0, mouseX, mouseY, 400);  

  translate(width/2, height/2,100);
  rotateX( mouseY*0.01 );
  rotateY( mouseX*0.01 );

  modelMesh.render();
  
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
