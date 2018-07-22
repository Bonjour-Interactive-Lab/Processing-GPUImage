/**
 * This example shows how to apply 1D Look up Table in order to change color grading of an image.
 * Use key [0-2] to change LUT
 * see example utils/Generate1DLUT for generating your neutral lut.
 * Import your LUT on a screenshot of your program in photoshop, use tool for color grading then export your custom LUT
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import java.awt.*;

PImage src;
PImage lut;
PImage[] lutsrc;
Filter filter;

//destination buffer
PGraphics filteredImg1;
String[] name = {"src", "filter: 1D Look Up Table"};

int nbFilter = 1;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  lutsrc = new PImage[3];
  lutsrc[0] = loadImage("LUT_cool.jpg");
  lutsrc[1] = loadImage("LUT_old.jpg");
  lutsrc[2] = loadImage("LUT_old_2.jpg");
  lut = lutsrc[0];
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
  filter = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);

  filteredImg1 = filter.getLut1DImage(src, lut);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(lut, imgw * 1, imgh * 0 + 40, imgw * 0.1, imgh * 0.1);

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

void keyPressed(){
  switch(key){
    case '0' :   lut = lutsrc[0];
    break;
    case '1' :   lut = lutsrc[1];
    break;
    case '2' :   lut = lutsrc[2];
    break;
  }
}
