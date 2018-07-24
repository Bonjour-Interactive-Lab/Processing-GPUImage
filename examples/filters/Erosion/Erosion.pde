/**
 * This example shows how to apply a dilation filter.
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
PImage src2;
Filter filter1, filter2;

//destination buffer
PGraphics filteredImg1, filteredImg2;
String[] name = {"src RGB", "filter: erosion RGB", "src BW", "filter: erosion BW"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  src2 = loadImage("BW.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 2;
  int h = imgh * 2;
  size(w, h, P2D);
}


void setup() {
  filter1 = new Filter(this, src.width, src.height);
  filter2 = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);

  filteredImg1 = filter1.getErosionRGBImage(src);
  filteredImg2 = filter1.getErosionImage(src2);

  int loop = 5;
  for (int i=0; i<loop; i++) {
    filteredImg1 = filter1.getErosionRGBImage(filteredImg1);
    filteredImg2 = filter1.getErosionImage(filteredImg2);
  }

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(src2, imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg2, imgw * 1, imgh * 1, imgw, imgh);

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
