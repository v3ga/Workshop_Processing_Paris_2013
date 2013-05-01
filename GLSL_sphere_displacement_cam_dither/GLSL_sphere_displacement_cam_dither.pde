/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Applying a 2D filter on top off a 3D renderer scene, which
 uses cam feed as displacement mapping
 —
 GLGraphics + GSVideo

*/
// --------------------------------------------------------
import codeanticode.glgraphics.*;
import codeanticode.gsvideo.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import javax.media.opengl.*;
boolean modelFilled = true;

// --------------------------------------------------------
TriangleMesh sphereMesh;
GLModel sphereModel;
GLGraphicsOffScreen offscreenDisp;
GLSLShader shaderDisp;
GLSLShader shaderModel;
GLSLShader shaderDither;
ToxiclibsSupport gfx;
GSCapture cam;
GLTexture texCam;

GLGraphicsOffScreen offscreenModel;

// --------------------------------------------------------
void captureEvent(GSCapture cam) 
{
  cam.read();
}

// --------------------------------------------------------
void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);

  cam = new GSCapture(this, 640, 480);
  texCam = new GLTexture(this);
  cam.setPixelDest(texCam);     
  cam.start();


  offscreenDisp = new GLGraphicsOffScreen(this, width/4, height/4);
  shaderDisp = new GLSLShader(this, "dist_sine_pulse_vert.glsl", "dist_sine_pulse_frag.glsl");
  shaderModel = new GLSLShader(this, "displacement_vert.glsl", "displacement_frag.glsl");
  shaderDither = new GLSLShader(this, "dither_vert.glsl", "dither_frag.glsl");

  // Creating the triangle mesh (CPU side)
  //sphereMesh=(TriangleMesh)new Sphere(new Vec3D(), 60).toMesh(20);
  //calcTextureCoordinates(sphereMesh);

  // Sending the model to GPU thanks to GLModel
  sphereModel = createSphereGLModel(50, 150);

  sphereModel.initTextures(1);
  sphereModel.setTexture(0, texCam /*offscreenDisp.getTexture()*/);
  sphereModel.updateTexCoords(0, texCoords);

  // Sets the normals.
  sphereModel.initNormals();
  sphereModel.updateNormals(normals);

  offscreenModel = new GLGraphicsOffScreen(this, width, height);


  gfx=new ToxiclibsSupport(this);
}

// --------------------------------------------------------
void draw()
{

  if (texCam.putPixelsIntoTexture()) 
  {


    // Model
    //  sphereModel.setTexture(0, offscreenDisp.getTexture());
    offscreenModel.beginDraw();
    offscreenModel.beginGL();
    offscreenModel.background(0);
    offscreenModel.stroke(255);
    offscreenModel.noFill();
    offscreenModel.translate(width/2, height/2, 200);
    offscreenModel.rotateY( frameCount*0.01 );
    offscreenModel.rotateX( frameCount*0.01 );
    shaderModel.start();
    shaderModel.setTexUniform("texDisplacement", texCam /*offscreenDisp.getTexture()*/);
    shaderModel.setFloatUniform("amplitude", map( mouseX, 0, width, 0, 50 ) );
    offscreenModel.model(sphereModel);

    shaderModel.stop();
    offscreenModel.endGL();
    offscreenModel.endDraw();
  }

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  shaderDither.start(); // Enabling shader.
  shaderDither.setFloatUniform("scale", 1.0);
  shaderDither.setTexUniform("texture", offscreenModel.getTexture());


  beginShape(QUADS);
  textureMode(NORMALIZED);
  texture(offscreenModel.getTexture());
  vertex(0, 0, 0, 0);
  vertex(2*width, 0, 1, 0); // why 2 ????
  vertex(2*width, 2*height, 1, 1); 
  vertex(0, 2*height, 0, 1);  
  endShape();

  shaderDither.stop();
  renderer.endGL();


  float s=0.25;
  image(offscreenModel.getTexture(), 0, 0, s*width, s*height);
}

// --------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    modelFilled = !modelFilled;
}

