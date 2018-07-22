/**
 * This example shows how to apply sobel, sobel edge and canny edges filter.
 * This filter can be useful when performing computer vision operations.
 * Move the mouse on the x-axis to change the hue resolution.
 *
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter sobel, sobelEdge, cannyEdge;

//destination buffer
PGraphics filteredImg1, filteredImg2, filteredImg3;
String[] name = {"src", "filter: Sobel", "filter: Sobel Edge", "filter: Canny Edge"};

int nbFilter = 3;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 2;
  int h = imgh * 2;
  size(w, h, P2D);
}


void setup() {
  /**
  * Remember : returns reference of object, not pointer or new instance. 
  * So if we want to have differents images with differents filters we will need to instantiate differents filters objects.
  */
  sobel = new Filter(this, src.width, src.height);
  sobelEdge = new Filter(this, src.width, src.height);
  cannyEdge = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width);
  
  filteredImg1 = sobel.getSobelImage(src, 0.25, 0.25);
  filteredImg2 = sobelEdge.getSobelEdgeImage(src, value, value);
  filteredImg3 = cannyEdge.getCannyEdgeImage(src, 0.25, 0.25, 1.0 - value);

  image(src          , imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1 , imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2 , imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg3 , imgw * 1, imgh * 1, imgw, imgh);

  noStroke();
  fill(20);
  rect(0, 0, width, 40);
  rect(0, imgh, width, 40);
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
