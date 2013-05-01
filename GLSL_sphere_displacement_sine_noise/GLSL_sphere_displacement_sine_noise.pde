/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Applying a 2D texture (generated from fragment shader) for vertices displacement
 —
 GLGraphics
 —
 Keys 
 ' ' : wireframe / filled 
 '1' : displacement pulse
 '2' : displacement noise 

 */
// --------------------------------------------------------
import codeanticode.glgraphics.*;
import processing.opengl.*;
import javax.media.opengl.*;

// --------------------------------------------------------
GLModel sphereModel;
GLGraphicsOffScreen offscreenDisp;
GLSLShader shaderDispSine, shaderDispNoise;
GLSLShader shaderDispCurrent;
GLSLShader shaderModel;
boolean modelFilled = true;

// --------------------------------------------------------
void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);

  offscreenDisp = new GLGraphicsOffScreen(this, width/4, height/4);
  shaderDispSine = new GLSLShader(this, "dist_sine_pulse_vert.glsl", "dist_sine_pulse_frag.glsl");
  shaderDispNoise = new GLSLShader(this, "noise_vert.glsl", "noise_frag.glsl");
  shaderModel = new GLSLShader(this, "displacement_vert.glsl", "displacement_frag.glsl");

  shaderDispCurrent = shaderDispSine;

  // Sending the model to GPU thanks to GLModel
  sphereModel = createSphereGLModel(100, 150);
  sphereModel.initTextures(1);
  sphereModel.setTexture(0, offscreenDisp.getTexture());
  sphereModel.updateTexCoords(0, texCoords);

  // Sets the normals.
  sphereModel.initNormals();
  sphereModel.updateNormals(normals);
}

// --------------------------------------------------------
void draw()
{
  background(0);

  // Shader for displacement mapping
  offscreenDisp.beginDraw();
  shaderDispCurrent.start();
  shaderDispCurrent.setFloatUniform("t", millis()/1000.0);
  shaderDispCurrent.setVecUniform("resolution", float(offscreenDisp.width), float(offscreenDisp.height));
  offscreenDisp.rect(0, 0, offscreenDisp.width, offscreenDisp.height);
  shaderDispCurrent.stop();
  offscreenDisp.endDraw();

  // Model
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, !modelFilled ? GL.GL_LINE : GL.GL_FILL );

  translate(width/2, height/2, 200);
  rotateY( frameCount*0.01 );
  rotateX( frameCount*0.01 );

  shaderModel.start();
  shaderModel.setTexUniform("texDisplacement", offscreenDisp.getTexture());
  shaderModel.setFloatUniform("amplitude", map( mouseX, 0, width, 0, 50 ) );
  renderer.model(sphereModel);

  renderer.gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL );

  shaderModel.stop();
  renderer.endGL();

  float s=0.25;
  image(offscreenDisp.getTexture(), 0, 0, s*width, s*height);
}

// ----------------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    modelFilled = !modelFilled;
  else if (key == '1')
    shaderDispCurrent = shaderDispSine;
  else if (key == '2')
    shaderDispCurrent = shaderDispNoise;
}

