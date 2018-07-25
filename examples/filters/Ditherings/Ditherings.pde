/**
 * This example shows various greyscale dithering effects (Bayer, Cluster Dot and Random).
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter filter1, 
       filter2, 
       filter3, 
       filter4, 
       filter5, 
       filter6, 
       filter7, 
       filter8; 

//destination buffer
PGraphics filteredImg1, 
          filteredImg2, 
          filteredImg3, 
          filteredImg4, 
          filteredImg5, 
          filteredImg6, 
          filteredImg7, 
          filteredImg8;
          
String[] name = {"src", "filter: Bayer2x2", "filter: Bayer3x3", "filter: Bayer4x4", "filter: Bayer8x8", "filter: ClusterDot4x4", "filter: ClusterDot8x8", "filter: ClusterDot5x3", "filter: Random3x3"};

int nbFilter = 8;
float scale = 0.65;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 4;
  int h = imgh * 3;
  size(w, h, P2D);
}


void setup() {
  /**
   * Remember : returns reference of object, not pointer or new instance. 
   * So if we want to have differents images with differents filters we will need to instantiate differents filters objects.
   */
  filter1 = new Filter(this, src.width, src.height);
  filter2 = new Filter(this, src.width, src.height);
  filter3 = new Filter(this, src.width, src.height);
  filter4 = new Filter(this, src.width, src.height);
  filter5 = new Filter(this, src.width, src.height);
  filter6 = new Filter(this, src.width, src.height);
  filter7 = new Filter(this, src.width, src.height);
  filter8 = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  //float value = norm(mouseX, 0, width) * 2.0;

  filteredImg1 = filter1.getDitherBayer2x2Image(src);
  filteredImg2 = filter2.getDitherBayer3x3Image(src);
  filteredImg3 = filter3.getDitherBayer4x4Image(src);
  filteredImg4 = filter4.getDitherBayer8x8Image(src);
  filteredImg5 = filter5.getDitherClusterDot4x4Image(src);
  filteredImg6 = filter6.getDitherClusterDot8x8Image(src);
  filteredImg7 = filter7.getDitherClusterDot5x3Image(src);
  filteredImg8 = filter8.getDitherRandom3x3Image(src);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2, imgw * 2, imgh * 0, imgw, imgh);
  image(filteredImg3, imgw * 3, imgh * 0, imgw, imgh);
  image(filteredImg4, imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg5, imgw * 1, imgh * 1, imgw, imgh);
  image(filteredImg6, imgw * 2, imgh * 1, imgw, imgh);
  image(filteredImg7, imgw * 3, imgh * 1, imgw, imgh);
  image(filteredImg8, imgw * 0, imgh * 2, imgw, imgh);

  noStroke();
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 4;
    int y = (i-x) / 4;
    fill(20);
    rect(x* imgw, y* imgh, imgw, 40);
    fill(240);
    text(name[i], x * imgw + 20, y * imgh + 20);
  }

  showFPS();
}

void showFPS() {
  int rfps = round(frameRate);
  float hueFPS = map(rfps, 0, 60, 0, 120);
  pushStyle();
  colorMode(HSB, 360, 1.0, 1.0);
  fill(hueFPS, 1.0, 1.0);
  textAlign(RIGHT, CENTER);
  textSize(14);
  text("FPS : "+rfps, width - 20, 20); 
  popStyle();
}

void keyPressed(){
  filteredImg1.save("filteredImg1.png");
  filteredImg2.save("filteredImg2.png");
  filteredImg3.save("filteredImg3.png");
  filteredImg4.save("filteredImg4.png");
  filteredImg5.save("filteredImg5.png");
  filteredImg6.save("filteredImg6.png");
  filteredImg7.save("filteredImg7.png");
  filteredImg8.save("filteredImg8.png");
}
