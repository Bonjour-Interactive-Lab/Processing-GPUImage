/**
 * This example shows various glitch effects (displace based on luma, RGB displace, Invert, Pixelate, Shift RGB and ShuffleRGB).
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter filter1, 
  filter2, 
  filter3, 
  filter4, 
  filter5, 
  filter6, 
  filter7, 
  filter8; 


String[] name = {"src", "filter: Invert RGB", "filter: Displace RGB", "filter: Shift RGB", "filter: Displace Luma", "filter: Shuffle RGB", "filter: Pixelate", "filter: StitchRGB", "filter: All together"};

int nbFilter = 8;
float scale = 0.65;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 4;
  int h = imgh * 3;
  size(w, h, P2D);
}


void setup() {
  /**
   * Remember : returns reference of object, not pointer or new instance. 
   * So if we want to have differents images with differents filters we will need to instantiate differents filters objects.
   */
  filter1 = new Filter(this, src.width, src.height);
  filter2 = new Filter(this, src.width, src.height);
  filter3 = new Filter(this, src.width, src.height);
  filter4 = new Filter(this, src.width, src.height);
  filter5 = new Filter(this, src.width, src.height);
  filter6 = new Filter(this, src.width, src.height);
  filter7 = new Filter(this, src.width, src.height);
  filter8 = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  float time = (millis() * 0.001);
  float intensity = noise(frameCount * 0.01);
  
  //simple gitch
  filter1.getGlitchInvert(src, intensity, time);
  filter2.getGlitchDisplaceRGB(src, intensity, time, 0.005, 0.0);
  filter3.getGlitchShiftRGB(src, intensity, time, 0.01, 0.0, 0.0, 0.015, 0.015, 0.0);
  filter4.getGlitchDisplaceLuma(src, intensity, time, 0.025, 0.005);
  filter5.getGlitchShuffleRGB(src, intensity, time, 1.5);
  filter6.getGlitchPixelated(src, intensity, time, 50);
  filter7.getGlitchStitch(src, intensity, time);
  
  //Full params + sequential glitch
  filter8.getGlitchInvert(src, intensity * 0.05, time, 2.0, 8.0, 0.15, 1.0, 0.25, 0.9, 0.75);
  filter8.getGlitchDisplaceRGB(filter8.getBuffer(), intensity * 0.25, time, 4.0, 15.0, 0.45, 0.75, 0.35, 0.154, 0.025, 0.005, 0.0);
  filter8.getGlitchShiftRGB(filter8.getBuffer(), intensity * 0.75, time, 1.0, 3.0, 0.65, 1.0, 0.35, 0.0, 0.005, 0.01, 0.0, 0.0, 0.015, 0.015, 0.0);
  filter8.getGlitchDisplaceLuma(filter8.getBuffer(), intensity, time, 2.0, 8.0, 0.5, 1.0, 0.25, 0.037, 0.01, 0.025, 0.005);
  filter8.getGlitchShuffleRGB(filter8.getBuffer(), intensity * 0.015, time, 2.0, 6.0, 0.4, 1.0, 0.25, 0.204, 0.06, 1.5);
  filter8.getGlitchPixelated(filter8.getBuffer(), intensity, time, 2.0, 8.0, 0.85, 1.0, 0.25, 0.0, 0.0, 100.0);
  filter8.getGlitchStitch(filter8.getBuffer(), intensity, time, 4.0, 8.0, 0.25, 1.0, 0.25, 2.35, 0.75);

  //use filter.getBuffer() to deirectly get the buffer used for the filter
  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filter1.getBuffer(), imgw * 1, imgh * 0, imgw, imgh);
  image(filter2.getBuffer(), imgw * 2, imgh * 0, imgw, imgh);
  image(filter3.getBuffer(), imgw * 3, imgh * 0, imgw, imgh);
  image(filter4.getBuffer(), imgw * 0, imgh * 1, imgw, imgh);
  image(filter5.getBuffer(), imgw * 1, imgh * 1, imgw, imgh);
  image(filter6.getBuffer(), imgw * 2, imgh * 1, imgw, imgh);
  image(filter7.getBuffer(), imgw * 3, imgh * 1, imgw, imgh);
  image(filter8.getBuffer(), imgw * 0, imgh * 2, imgw, imgh);

  noStroke();
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 4;
    int y = (i-x) / 4;
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

void keyPressed() {
  filter1.getBuffer().save("filteredImg1.png");
  filter2.getBuffer().save("filteredImg2.png");
  filter3.getBuffer().save("filteredImg3.png");
  filter4.getBuffer().save("filteredImg4.png");
  filter5.getBuffer().save("filteredImg5.png");
  filter6.getBuffer().save("filteredImg6.png");
  filter7.getBuffer().save("filteredImg7.png");
  filter8.getBuffer().save("filteredImg8.png");
}
