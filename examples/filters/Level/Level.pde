/**
 * This example shows how to manipulation the levels of an image as independent components or all together.
 * You can also manipule each component such as min/max input, min/max output and gamma using simplified methods
 * See how level works on Photoshop or other image software for more informations
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;

PImage src;
Filter levelRGB, levelGrey, gammaRGB, gammaGrey, inputRGB, inputGrey, outputRGB, outputGrey;

//destination buffer
PGraphics filteredImg1, filteredImg2, filteredImg3, filteredImg4, filteredImg5, filteredImg6, filteredImg7, filteredImg8;
String[] name = {"src", "filter: level RGB", "filter: level Grey", "filter: Gamma RGB (red)", "filter: Gamma grey", "filter: Input RGB", "filter: Input grey", "filter: Output RGB", "filter: Output grey"};

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
  levelRGB = new Filter(this, src.width, src.height);
  levelGrey = new Filter(this, src.width, src.height);
  gammaRGB = new Filter(this, src.width, src.height);
  gammaGrey = new Filter(this, src.width, src.height);
  inputRGB = new Filter(this, src.width, src.height);
  inputGrey = new Filter(this, src.width, src.height);
  outputRGB = new Filter(this, src.width, src.height);
  outputGrey = new Filter(this, src.width, src.height);
}

void draw() {
  background(20);
  //float value = norm(mouseX, 0, width) * 2.0;

  filteredImg1 = levelRGB.getLevelImage(src, 80.0, 22.0, 41.0, 243.0, 255.0, 203.0, 0.63, 1.44, 1.66, 0.0, 5.0, 41.0, 238.0, 231.0, 175.0);
  filteredImg2 = levelGrey.getLevelImage(src, 80.0, 225, 1.03, 60.0, 255.0);
  filteredImg3 = gammaRGB.getLevelGammaImage(src, 0.25, 1.0, 1.0);
  filteredImg4 = gammaGrey.getLevelGammaImage(src, 0.25);
  filteredImg5 = inputRGB.getLevelInputImage(src, 80.0, 22.0, 41.0, 243.0, 255.0, 203.0);
  filteredImg6 = inputGrey.getLevelInputImage(src, 80.0, 240.0);
  filteredImg7 = outputRGB.getLevelOutputImage(src, 100.0, 22.0, 41.0, 243.0, 255.0, 203.0);
  filteredImg8 = outputGrey.getLevelOutputImage(src, 80.0, 230.0);

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(filteredImg1, imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg2, imgw * 2, imgh * 0, imgw, imgh);
  image(filteredImg3, imgw * 3, imgh * 0, imgw, imgh);
  image(filteredImg4, imgw * 0, imgh * 1, imgw, imgh);
  image(filteredImg5, imgw * 1, imgh * 1, imgw, imgh);
  image(filteredImg6, imgw * 2, imgh * 1, imgw, imgh);
  image(filteredImg7, imgw * 3, imgh * 1, imgw, imgh);
  image(filteredImg8, imgw * 0, imgh * 2, imgw, imgh);

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
