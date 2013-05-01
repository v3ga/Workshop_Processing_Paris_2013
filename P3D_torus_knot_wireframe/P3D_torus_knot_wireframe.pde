/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 —
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 —
 Torus Knot

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
ToxiclibsSupport gfx;

// --------------------------------------------------------
void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);

  torusKnot = new TorusKnot(120,2,5);
  gfx = new ToxiclibsSupport(this);
}

// --------------------------------------------------------
void draw()
{
  background(0);
  translate(width/2, height/2);
  rotateX( map(mouseY,0,height,-PI,PI) );
  rotateY( map(mouseX,0,width,-PI,PI) );
  noFill();
  stroke(255);
  gfx.mesh(torusKnot.mesh);
}


