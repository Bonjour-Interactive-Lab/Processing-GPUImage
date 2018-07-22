/**
 * This example shows how to apply filter in a for loop sequence.
 * Here we use a 5x5 median filter which demands lot of process in order to show performance
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter filter;

//destination buffer
PGraphics filteredImg;
String[] name = {"src", "filter: median5x5"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 2;
  int h = imgh;
  size(w, h, P2D);
}


void setup() {
  filter = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);

  filteredImg = filter.getMedian5x5Image(src);
  for (int i=0; i<25; i++) {
    filteredImg = filter.getMedian5x5Image(filteredImg);
  }

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg, imgw * 1, imgh * 0, imgw, imgh);

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
