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
  float value = norm(mouseX, 0, width) * TWO_PI;
  float angle = value;//frameCount * 0.001;
  filter1.getDitherBayer2x2(src, angle);
  filter2.getDitherBayer3x3(src, angle);
  filter3.getDitherBayer4x4(src, angle);
  filter4.getDitherBayer8x8(src, angle);
  filter5.getDitherClusterDot4x4(src, angle);
  filter6.getDitherClusterDot8x8(src, angle);
  filter7.getDitherClusterDot5x3(src, angle);
  filter8.getDitherRandom3x3(src, angle);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filter1.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);
  image(filter2.getBuffer(), imgw * 2, imgh * 0, imgw, imgh);
  image(filter3.getBuffer(), imgw * 3, imgh * 0, imgw, imgh);
  image(filter4.getBuffer(), imgw * 0, imgh * 1, imgw, imgh);
  image(filter5.getBuffer(), imgw * 1, imgh * 1, imgw, imgh);
  image(filter6.getBuffer(), imgw * 2, imgh * 1, imgw, imgh);
  image(filter7.getBuffer(), imgw * 3, imgh * 1, imgw, imgh);
  image(filter8.getBuffer(), imgw * 0, imgh * 2, imgw, imgh);

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
  filter1.getBuffer().save("filteredImg1.png");
  filter2.getBuffer().save("filteredImg2.png");
  filter3.getBuffer().save("filteredImg3.png");
  filter4.getBuffer().save("filteredImg4.png");
  filter5.getBuffer().save("filteredImg5.png");
  filter6.getBuffer().save("filteredImg6.png");
  filter7.getBuffer().save("filteredImg7.png");
  filter8.getBuffer().save("filteredImg8.png");
}
