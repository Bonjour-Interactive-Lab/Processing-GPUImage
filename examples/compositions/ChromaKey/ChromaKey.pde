/**
 * This example shows how to apply a High Pass filter.
 * Move the mouse on the x-axis to change the blend ratio.
 *
 * This filter can be used as a combination with an Overlay composition in order to accentuate the image.
 * @see more on the other/accentutation process example
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PGraphics mask;
PImage src, base, maskimg;
Compositor comp1, comp2;

String[] name = {"src", "base", "Chroma key on alpha", "Chroma key on base image"};

float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  base = loadImage("base.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 2;
  int h = imgh * 2;
  size(w, h, P2D);
}


void setup() {
  mask = createGraphics(imgw, imgh, P2D);
  mask.smooth(8);
  mask.beginDraw();
  mask.background(0);
  mask.endDraw();
  comp1 = new Compositor(this, src.width, src.height);
  comp2 = new Compositor(this, src.width, src.height);
}

void draw() {
  background(20);
  
  //PGraphics mess up with UV coordinates
  comp1.getChromaKey(src, 11.0, 165, 70.0);
  comp2.getChromaKey(src, base, 11.0, 165, 70.0);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(base, imgw * 1, imgh * 0, imgw, imgh);
  image(comp1.getBuffer(), imgw * 0, imgh * 1, imgw, imgh);
  image(comp2.getBuffer(), imgw * 1, imgh * 1, imgw, imgh);

  noStroke();
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 2;
    int y = (i-x) / 2;
    fill(20);
    rect(x * imgw, y * imgh, imgw, 40);
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
