/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Drawing a 3D scene to a smaller texture, with GL_NEAREST sampling enabled resulting in a pixelated rendering
 —
 GLGraphics 1.0.0

*/

// --------------------------------------------------------
import codeanticode.glgraphics.*;
import processing.opengl.*;

GLGraphicsOffScreen offscreen,offscreenDownSample;

// --------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);

  offscreen = new GLGraphicsOffScreen(this,width, height);
  
  GLTextureParameters params = new GLTextureParameters();
  params.minFilter = GLConstants.NEAREST_SAMPLING;
  params.magFilter = GLConstants.NEAREST_SAMPLING;
  offscreenDownSample = new GLGraphicsOffScreen(this,width/10, height/10,params);
  
  noStroke();
}

// --------------------------------------------------------
void draw()
{
  // Render to offscreen
  offscreen.beginDraw();
  render(offscreen);
  offscreen.endDraw();
  
  // Downsample = render previous image in a smaller texture ! 
  offscreenDownSample.beginDraw();
  offscreenDownSample.image(offscreen.getTexture(),0,0,offscreenDownSample.width,offscreenDownSample.height);
  offscreenDownSample.endDraw();

  // Drawing downsample image as background
  image(offscreenDownSample.getTexture(),0,0,width,height);

  // Drawing half image on top
  beginShape(QUADS);
    textureMode(NORMALIZED);
    texture(offscreen.getTexture());
    vertex(0,0,0, 0,0);
    vertex(width/2,0,0, 0.5,0);
    vertex(width/2,height,0, 0.5,1);
    vertex(0,height,0, 0,1);
  endShape();
}

// --------------------------------------------------------
void render(PGraphicsOpenGL g)
{
  g.lights();
  g.translate(g.width/2, g.height/2);
  g.background(0);
  g.noStroke();
  g.rotateX(radians(frameCount/2));
  g.rotateY(radians(frameCount/2));
  g.box(260);
}

