/**
 * This example shows how to use datamoshing shader
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import processing.video.*;

Movie movie;
PGraphics current;
Filter filter1, filter2, filter3;

//destination buffer
String[] name = {"src", "filter: Datamoshing", "filter: Datamoshing3x3", "filter: Datamoshing5x5"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {

  imgw = 450;
  imgh = 450;
  int w = imgw * 2;
  int h = imgh * 2; 
  size(w, h, P2D);
}


void setup() {
  movie = new Movie(this, "coverrsources.mp4");
  movie.loop();

  current = createGraphics(width, height, P2D);
  filter1 = new Filter(this, width, height);
  filter2 = new Filter(this, width, height);
  filter3 = new Filter(this, width, height);
}

void draw() {
  background(20);

  if (movie.available()) {
    movie.read(); // Read the new frame from the camera

    current.beginDraw();
    current.image(movie, 0.0, 0.0, width, height);
    current.endDraw();
  }
  float threshold = noise(millis() * 0.0001, frameCount * 0.01) * 0.15;
  float offsetRGB = noise(frameCount * 0.0125, millis() * 0.005) * 0.005;
  float size = 5.0;
  float minVelocity = 0.0;
  float maxVelocity = 0.35;
  float offsetSobel = 0.1;
  float lambda = 1.0;

  filter1.getDatamoshing(current, minVelocity, maxVelocity, offsetSobel, lambda, threshold, size, offsetRGB);
  filter2.getDatamoshing3x3(current, minVelocity, maxVelocity, offsetSobel, lambda, threshold, size, offsetRGB);
  filter3.getDatamoshing5x5(current, minVelocity, maxVelocity, offsetSobel, lambda, threshold, size, offsetRGB);

  /**
  quick datamoshing with less params. Based params are : 
  
  float minVelocity = 0.01;
  float maxVelocity = 0.5;
  float offsetSobel = 0.1;
  float lambda = 1.0;
  */
   /*
   filter1.getDatamoshing(current, threshold, size, offsetRGB);
   filter2.getDatamoshing3x3(current, threshold, size, offsetRGB);
   filter3.getDatamoshing5x5(current, threshold, size, offsetRGB);
   */


  image(current, imgw * 0, imgh * 0, imgw, imgh);
  image(filter1.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);
  image(filter2.getBuffer(), imgw * 0, imgh * 1, imgw, imgh);
  image(filter3.getBuffer(), imgw * 1, imgh * 1, imgw, imgh);

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
