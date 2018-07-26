/**
 * This example shows how to apply 1D ramp table in order to change color grading of an image based on its luma value.
 * Use key 'a' & 'z' to change the RAMP
 * Create a gradient texture on your favorite image software to generate a RAMP texture.
 * By default the library use a 512*512 ramp but you can set it ayt any size.
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import java.awt.*;

PImage src;
PImage ramp;
PImage[] rampsrc;
int index;
Filter filter;

//destination buffer
PGraphics filteredImg1;
String[] name = {"src", "filter: 1D Look Up Table"};

int nbFilter = 1;
float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  rampsrc = new PImage[11];
  for(int i=0; i<rampsrc.length; i++){
    rampsrc[i] = loadImage("ramp_"+i+".png");
  }
  ramp = rampsrc[0];
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

  filteredImg1 = filter.getRamp1DImage(src, ramp);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(ramp, imgw * 1, imgh * 0 + 40, imgw * 0.1, imgh * 0.1);

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
  if(key == 'a'){
    index ++;
    if(index > rampsrc.length-1){
      index = 0;
    }
  }else if(key == 'z'){
    index --;
    if(index < 0){
      index =  rampsrc.length-1;
    }
  }
  
  ramp = rampsrc[index];
}
