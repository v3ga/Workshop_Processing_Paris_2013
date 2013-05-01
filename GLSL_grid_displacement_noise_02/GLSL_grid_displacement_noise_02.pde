/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Plane distorted along a noise function
 —
 GLGraphics
 —
 Displacement code (noise) from 
 http://glsl.heroku.com/e#1413.0

*/

// --------------------------------------------------------
import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;

// --------------------------------------------------------
GLModel model, model2;
GLSLShader shader;

float dim = 700;
int resx = 300; // change if too slow
int resy = 300; // change if too slow
float[] vertices;
float zTarget = 0;
float z = 0;

// --------------------------------------------------------
void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);

  float d = dim;
  float x = -d/2;
  float y = -d/2;
  int i, j;
  float stepx = d/float(resx-1);
  float stepy = d/float(resy-1);

  shader = new GLSLShader(this, "noise_vert.glsl", "noise_frag.glsl");

  vertices = new float[3*resx*resy];
    int indexVertex = 0;
  for (j=0;j<resy;j++)
  {
    x = -d/2;
    for (i=0;i<resx;i++)
    {
      vertices[indexVertex*3] = x;
      vertices[indexVertex*3+1] = y;
      vertices[indexVertex*3+2] = 0;

      x+=stepx;
      indexVertex++;
    }
    y+=stepy;
  }

  int nbFaces = (resx-1)*(resy-1)*2;
  model2 = new GLModel(this, nbFaces*3, GLModel.TRIANGLES, GLModel.STATIC);
  model2.beginUpdateVertices();
  int offset=0;
  indexVertex=0;
  for (j=0;j<resy-1;j++)
  {
    for (i=0;i<resx-1;i++)
    {  
      offset = 3*(i+j*resx);      
      model2.updateVertex(indexVertex++, vertices[offset],vertices[offset+1],0);
      model2.updateVertex(indexVertex++, vertices[offset+3],vertices[offset+3+1],0);
      model2.updateVertex(indexVertex++, vertices[offset+3*resx],vertices[offset+3*resx+1],0);

      model2.updateVertex(indexVertex++, vertices[offset+3],vertices[offset+3+1],0);
      model2.updateVertex(indexVertex++, vertices[offset+3*(resx+1)],vertices[offset+3*(resx+1)+1],0);
      model2.updateVertex(indexVertex++, vertices[offset+3*resx],vertices[offset+3*resx+1],0);
    }
  }
  model2.endUpdateVertices();
}


// --------------------------------------------------------
void draw()
{
  z += (zTarget-z)*0.2;

  background(0);
  stroke(255);
  fill(255);
  translate(width/2, height/2, z);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(map(mouseY, 0, height, -PI, PI));
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  shader.start();
  shader.setFloatUniform("time", millis()/1000.0f);
  shader.setFloatUniform("gridSize", dim);
  shader.setFloatUniform("amplitude", 70.0);
//  model.render();
  model2.render();
  shader.stop();


  renderer.endGL();
}

// --------------------------------------------------------
void mousePressed()
{
  zTarget = 300;
}

// --------------------------------------------------------
void mouseReleased()
{
  zTarget = 0;
}

