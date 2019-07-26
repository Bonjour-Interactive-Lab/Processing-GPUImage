/**
 * This example shows threshold and color threshold filter.
 * Move the mouse on the x-axis to change the desaturation between 0 and 255
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter threshold, cThreshold;

//destination buffer
PGraphics filteredImg1, filteredImg2;
String[] name = {"src", "filter: Threshold", "filter: Color threshold"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * (nbFilter + 1);
  int h = imgh * 1;
  size(w, h, P2D);
}


void setup() {
  /**
   * Remember : returns reference of object, not pointer or new instance. 
   * So if we want to have differents images with differents filters we will need to instantiate differents filters objects.
   */
  threshold = new Filter(this, src.width, src.height);
  cThreshold = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width) * 255.0;

  filteredImg1 = threshold.getThreshold(src, value);
  filteredImg2 = cThreshold.getColorThreshold(src, value, value - 50, value - 100);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2, imgw * 2, imgh * 0, imgw, imgh);

  noStroke();
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
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
