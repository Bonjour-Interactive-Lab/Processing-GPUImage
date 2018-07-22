/**
 * This example shows how to manipulation the contrast saturation and brighntess of an image as independent components or all together.
 *
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter csb, contrast, saturation, brightness;

//destination buffer
PGraphics filteredImg1, filteredImg2, filteredImg3, filteredImg4, filteredImg5;
String[] name = {"src", "filter: Contrast Saturation brightness", "filter: Contrast", "filter: Saturation", "filter: Brightness"};

int nbFilter = 4;
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
  csb = new Filter(this, src.width, src.height);
  contrast = new Filter(this, src.width, src.height);
  saturation = new Filter(this, src.width, src.height);
  brightness = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width) * 200;

  filteredImg1 = csb.getContrastSaturationBrightnessImage(src, 150.0, 25, 100.0);
  filteredImg2 = contrast.getContrastImage(src, value);
  filteredImg3 = saturation.getSaturationImage(src, value);
  filteredImg4 = brightness.getBrightnessImage(src, value);

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
