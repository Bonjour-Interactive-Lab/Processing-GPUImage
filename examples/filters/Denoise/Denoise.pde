/**
 * This example shows various filtering technics for noise reduction on an image
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter bilateral, denoise, median3x3, median5x5;

//destination buffer
PGraphics filteredImg1, filteredImg2, filteredImg3, filteredImg4;
String[] name = {"src", "filter: bilateral", "filter: denoise", "filter: median3x3", "filter: median5x5"};

int nbFilter = 4;
float scale = 1.0;
int imgw , imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 3;
  int h = imgh * 2;
  size(w, h, P2D);
}


void setup() {
  bilateral = new Filter(this, src.width, src.height);
  denoise = new Filter(this, src.width, src.height);
  median3x3 = new Filter(this, src.width, src.height);
  median5x5 = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  
  filteredImg1 = bilateral.getBilateralImage(src);
  filteredImg2 = denoise.getDenoiseImage(src);
  filteredImg3 = median3x3.getMedian3x3Image(src);
  filteredImg4 = median5x5.getMedian5x5Image(src);
  
  image(src          , imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1 , imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2 , imgw * 2, imgh * 0, imgw, imgh);
  image(filteredImg3 , imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg4 , imgw * 1, imgh * 1, imgw, imgh);
  
  noStroke();
  fill(20);
  rect(0, 0, width, 40);
  rect(0, imgh, width, 40);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for(int i=0; i<name.length; i++){
    int x = i % 3;
    int y = (i-x) / 3;
    text(name[i], x * imgw + 20, y * imgh + 20);
  }
  
  showFPS();
}

void showFPS(){
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
