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
String[] name = {"src RGB", "filter: dilation RGB", "src BW", "filter: dilation BW"};

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

  filter1.getDilationRGB(src);
  filter2.getDilation(src2);

  int loop = 5;
  for (int i=0; i<loop; i++) {
    filter1.getDilationRGB(filter1.getBuffer());
    filter2.getDilation(filter2.getBuffer());
  }

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filter1.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);
  image(src2, imgw * 0, imgh * 1, imgw, imgh);
  image(filter2.getBuffer(), imgw * 1, imgh * 1, imgw, imgh);

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
