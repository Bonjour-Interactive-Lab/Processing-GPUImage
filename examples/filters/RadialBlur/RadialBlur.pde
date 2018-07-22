/**
 * This example shows various radial blur filters.
 * If you are using a GPU chipset or if you running your program on a low GPU machine, you will prefer optimized blur
 * Move the mouse on the x-axis to change the blur size resolution.
 *
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter radial, low, med, high;

//destination buffer
PGraphics filteredImg1, filteredImg2, filteredImg3, filteredImg4, filteredImg5;
String[] name = {"src", "filter: radial blur", "filter: radial blur low quality", "filter: radial blur medium quality", "filter: radial blur high quality"};

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
  radial = new Filter(this, src.width, src.height);
  low = new Filter(this, src.width, src.height);
  med = new Filter(this, src.width, src.height);
  high = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float nx = norm(mouseX, 0, width);
  float ny = norm(mouseY, 0, height);
  float cx = src.width/2;
  float cy = src.height/2;
  float size = nx;

  filteredImg1 = radial.getRadialBlurImage(src, cx, cy, size, 25);
  filteredImg2 = low.getRadialBlurLowImage(src, cx, cy, size);
  filteredImg3 = med.getRadialBlurMediumImage(src, cx, cy, size);
  filteredImg4 = high.getRadialBlurHighImage(src, cx, cy, size);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2, imgw * 2, imgh * 0, imgw, imgh);
  image(filteredImg3, imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg4, imgw * 1, imgh * 1, imgw, imgh);

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
