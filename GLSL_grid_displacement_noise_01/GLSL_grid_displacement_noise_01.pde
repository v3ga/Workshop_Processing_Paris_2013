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
GLModel model;
GLSLShader shader;

float dim = 700;
int resx = 300; // change if too slow
int resy = 300; // change if too slow
float zTarget = 0;
float z = 0;

// --------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);
  
  float d = dim;
  float x = -d/2;
  float y = -d/2;
  int i,j;
  float stepx = d/float(resx-1);
  float stepy = d/float(resy-1);
  
    shader = new GLSLShader(this, "noise_vert.glsl", "noise_frag.glsl");
  
    model = new GLModel(this, resx*resy, GLModel.POINTS, GLModel.STATIC);
    model.beginUpdateVertices();

  int indexVertex = 0;
  for (j=0;j<resy;j++)
  {
    x = -d/2;
    for (i=0;i<resx;i++)
    {
      model.updateVertex(indexVertex, x, y, 0);
      x+=stepx;
      indexVertex++;
    }
    y+=stepy;
  }
    model.endUpdateVertices();

}

// --------------------------------------------------------
void draw()
{
  z += (zTarget-z)*0.2;
  
  background(0);
  stroke(255);
  fill(255);
  translate(width/2, height/2,z);
  rotateY(map(mouseX,0,width,-PI,PI));
  rotateX(map(mouseY,0,height,-PI,PI));
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  shader.start();
  shader.setFloatUniform("time", millis()/1000.0f);
  shader.setFloatUniform("gridSize", dim);
  shader.setFloatUniform("amplitude", 70.0);
  model.render();
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


