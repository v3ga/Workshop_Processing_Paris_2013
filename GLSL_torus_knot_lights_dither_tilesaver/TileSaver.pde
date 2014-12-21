class GLTileSaver
{
  int res = 2;
  int numTilesTodo = 0;
  int numTilesDone = 0;
  boolean running = false;
  int tileX = 0;
  int tileY = 0;
  
  PGraphicsOpenGL g;
  
  GLTileSaver(int res_)
  {
    this.res = res_;
    this.numTilesTodo = res*res;
  }

  void begin(PGraphicsOpenGL g_)
  {
    this.g = g_;
    float ratio = float(g.height)/float(g.width);
    if (running)
    {
      println("tile("+tileX+","+tileY+")");
      
      float stepX  = 1.0/float(this.res);
      float left = map(tileX,0,res,-0.5,0.5);
      float right = left+stepX;

      float stepY  = ratio/float(this.res);
      float bottom = map(tileY,0,res,-ratio*0.5,ratio*0.5);
      float top = bottom+stepY;

      this.g.frustum(left,right,bottom,top,1,4000);
      println("g.frustum("+left+","+right+","+bottom+","+top+")");
    }
    else
    {
      this.g.frustum(-0.5,0.5,-ratio*0.5,ratio*0.5,1,4000);
    }
  }
  
  void end()
  {
    if (running)
    {
     saveFrame(getFilename());
      
      tileX+=1;
      if (tileX>=res){
        tileX=0;
        tileY+=1;
      }
      numTilesDone++;
      if (numTilesDone == numTilesTodo){
        running = false;
      }
    }
  
  }
  
  void run()
  {
    tileX = 0;
    tileY = 0;
    numTilesDone = 0;
    running = true;
  }
  
  void assemble()
  {
    PGraphics pg = createGraphics(res*width, res*height,P2D);
    pg.beginDraw();
    for (tileY=0;tileY<res;tileY++)
    {
      for (tileX=0;tileX<res;tileX++)
      {
        PImage img = loadImage(getFilename());        
        pg.image(img,tileX*width,tileY*height,width,height);
      }
    }
    pg.endDraw();
    
    pg.save("exports/_export.png");
  }
  
  String getFilename()
  {
    return getPrefix()+"export.png";
  }

  String getPrefix()
  {
    return "exports/"+tileX+"_"+tileY+"_";
  }
  
}
