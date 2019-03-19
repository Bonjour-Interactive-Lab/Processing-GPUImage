/**
 * This example shows how to apply and perform a hue based segmentation filter.
 * This filter can be useful when performing computer vision operation based on colors.
 * Move the mouse on the x-axis to change the hue resolution.
 *
 * This filter can be used as a combination with a blur or bilateral filter to have a better hue segmentation.
 * @see more on the other/ProcessHueSegmentation example
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter filter1, filter2;

String[] name = {"src", "filter: Hue Segmentation", "filter: Hue Segmentation"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * (nbFilter + 1);
  int h = imgh;
  size(w, h, P2D);
}


void setup() {
  filter1 = new Filter(this, src.width, src.height);
  filter2 = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width) * 360;

  filter1.getHueSegmentation(src);
  filter2.getHueSegmentation(src, value);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filter1.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);
  image(filter2.getBuffer(), imgw * 2, imgh * 0, imgw, imgh);

  noStroke();
  fill(20);
  rect(0, 0, width, 40);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 2;
    int y = (i-x) / 2;
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
