/**
 * This example shows filter for gamma correction.
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import java.awt.*;

PImage src;
Filter gamma;

String[] name = {"src", "filter: Gamma correction"};

int nbFilter = 1;
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
  gamma = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  //float value = norm(mouseX, 0, width) * 2.0;

  gamma.getGammaCorrection(src, 2.2);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(gamma.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);

  noStroke();
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 2;
    int y = (i-x) / 2;
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
