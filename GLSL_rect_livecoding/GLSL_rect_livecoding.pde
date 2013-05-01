/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Using timestamp of a file to reload a fragment shader for «livecoding»
 —
 GLGraphics
 —
 Displacement code (noise) from 
 http://glsl.heroku.com/e#1413.0

*/

// --------------------------------------------------------
import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;

// --------------------------------------------------------
GLSLShader theShader;
String fileVertName = "dist_sine_pulse_vert.glsl";
String fileFragName = "dist_sine_pulse_frag.glsl";
File fileFragShader;
long fileShaderTimeStamp;

// --------------------------------------------------------
void setup() 
{
  size(800, 600, GLConstants.GLGRAPHICS);
  noStroke();
  fileFragShader = new File(dataPath(fileFragName));
  fileShaderTimeStamp = fileFragShader.lastModified();
  reloadShader();
}

// --------------------------------------------------------
void draw()
{
  // Livecoding
  // Reload only if timestamp of file is modified
  if (fileFragShader.lastModified() > fileShaderTimeStamp){
    fileShaderTimeStamp = fileFragShader.lastModified();
    reloadShader();
  }
  
  // Rendering on screen
  theShader.start();
  theShader.setFloatUniform("t", millis()/1000.0);
  theShader.setVecUniform("resolution", float(width), float(height));
  rect(0, 0, width, height);
  theShader.stop();

}

// --------------------------------------------------------
void reloadShader()
{
  theShader = new GLSLShader(this, fileVertName, fileFragName);
}

