/**
 * This example shows how to apply a High Pass filter.
 * Move the mouse on the x-axis to change the high-pass radius.
 *
 * This filter can be used as a combination with an Overlay composition in order to accentuate the image.
 * @see more on the other/accentutation process example
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter filter;
Compositor comp;

//destination buffer
String[] name = {"src", "HighPass + Desaturation", "Overlay blending"};

float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 3;
  int h = imgh;
  size(w, h, P2D);
}


void setup() {
  filter = new Filter(this, src.width, src.height);
  comp = new Compositor(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width) * 2.0;

  PGraphics t = createGraphics(src.width, src.height, P2D);
  t.beginDraw();
  t.image(src, 0, 0);
  t.endDraw();

  //1- High pass the source image
  filter.getHighPass(src, value);
  //2- Desaturate the result image
  filter.getDesaturate(filter.getBuffer(), 100.0);
  //3- Compose it with the source image as overlay
  comp.getBlendOverlayImage(filter.getBuffer(), src, 100.0);


  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filter.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);
  image(comp.getBuffer(), imgw * 2, imgh * 0, imgw, imgh);

  noStroke();
  fill(20);
  rect(0, 0, width, 40);
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
