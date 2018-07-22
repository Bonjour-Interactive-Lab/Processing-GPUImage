/**
 * This example shows various gaussian blur filters.
 * If you are using a GPU chipset or if you running your program on a low GPU machine, you will prefer optimized blur
 * Move the mouse on the x-axis to change the blur size.
 *
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter gaussian, low, med, high, ultrahigh;

//destination buffer
PGraphics filteredImg1, filteredImg2, filteredImg3, filteredImg4, filteredImg5;
String[] name = {"src", "filter: gaussian blur", "filter: gaussian blur low quality", "filter: gaussian blur medium quality", "filter: gaussian blur high quality", "filter: gaussian blur ultra high quality"};

int nbFilter = 5;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 3;
  int h = imgh * 2;
  size(w, h, P2D);
}


void setup() {
  /**
  * Remember : returns reference of object, not pointer or new instance. 
  * So if we want to have differents images with differents filters we will need to instantiate differents filters objects.
  */
  gaussian = new Filter(this, src.width, src.height);
  low = new Filter(this, src.width, src.height);
  med = new Filter(this, src.width, src.height);
  high = new Filter(this, src.width, src.height);
  ultrahigh = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width) * 5.0;

  filteredImg1 = gaussian.getGaussianBlurImage(src, value, value);
  filteredImg2 = low.getGaussianBlur5x5Image(src, value);
  filteredImg3 = med.getGaussianBlur7x7Image(src, value);
  filteredImg4 = high.getGaussianBlur9x9Image(src, value);
  filteredImg5 = ultrahigh.getGaussianBlur13x13Image(src, value);

  image(src         , imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2, imgw * 2, imgh * 0, imgw, imgh);
  image(filteredImg3, imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg4, imgw * 1, imgh * 1, imgw, imgh);
  image(filteredImg5, imgw * 2, imgh * 1, imgw, imgh);

  noStroke();
  fill(20);
  rect(0, 0, width, 40);
  rect(0, imgh, width, 40);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
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
