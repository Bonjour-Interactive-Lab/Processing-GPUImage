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

PImage src, base;
Compositor composition;
int count = 0;

//destination buffer
PGraphics filteredImg;
String[] name = {"src", "base", "blend: add"};
String[] blending = { "add", "average", "color burn", "color dodge", "color", "darken", "difference", "exclusion", 
  "glow", "hard light", "hard mix", "hue", "lighten", "linear burn", "linear dodge", "linear light", 
  "luminosity", "multiply", "negation", "overlay", "pheonix", "pin light", "reflect", "saturation", 
   "screen", "soft light", "substract", "vivid light"};

float scale = 1.0;
int imgw, imgh;

void settings() {
  src = loadImage("src.png");
  base = loadImage("base.png");
  imgw = ceil(src.width * scale);
  imgh = ceil(src.height * scale);
  int w = imgw * 3;
  int h = imgh;
  size(w, h, P2D);
}


void setup() {
  composition = new Compositor(this, src.width, src.height);
}

void draw() {
  background(20);
  float value = norm(mouseX, 0, width) * 100;
  name[2] = "filter: "+blending[count];
  println(blending.length);
  
  switch(count) {
  case 0 : 
    filteredImg = composition.getBlendAddImage(src, base, value); //add
    break;
  case 1 : 
    filteredImg = composition.getBlendAverageImage(src, base, value); //average
    break;
  case 2 : 
    filteredImg = composition.getBlendColorBurnImage(src, base, value); //color burn
    break;
  case 3 : 
    filteredImg = composition.getBlendColorDodgeImage(src, base, value); //color dodge
    break;
  case 4 : 
    filteredImg = composition.getBlendColorImage(src, base, value); //color
    break;
  case 5 : 
    filteredImg = composition.getBlendDarkenImage(src, base, value); //darken
    break;
  case 6 : 
    filteredImg = composition.getBlendDifferenceImage(src, base, value); //difference
    break;
  case 7 : 
    filteredImg = composition.getBlendExclusionImage(src, base, value); //exclusion
    break;
  case 8 : 
    filteredImg = composition.getBlendGlowImage(src, base, value); //glow
    break;
  case 9 : 
    filteredImg = composition.getBlendHardLightImage(src, base, value); //hard light
    break;
  case 10 : 
    filteredImg = composition.getBlendHardMixImage(src, base, value); //hard mix
    break;
  case 11 : 
    filteredImg = composition.getBlendHueImage(src, base, value); //hue
    break;
  case 12 : 
    filteredImg = composition.getBlendLightenImage(src, base, value); //lighten
    break;
  case 13 : 
    filteredImg = composition.getBlendLinearBurnImage(src, base, value); //linear burn
    break;
  case 14 : 
    filteredImg = composition.getBlendLinearDodgeImage(src, base, value); //linear dodge
    break;
  case 15 : 
    filteredImg = composition.getBlendLinearLightImage(src, base, value); //linear light
    break;
  case 16 : 
    filteredImg = composition.getBlendLuminosityImage(src, base, value); //luminosity
    break;
  case 17 : 
    filteredImg = composition.getBlendMultiplyImage(src, base, value); //multiply
    break;
  case 18 : 
    filteredImg = composition.getBlendNegationImage(src, base, value); //negation
    break;
  case 19 : 
    filteredImg = composition.getBlendOverlayImage(src, base, value); //overlay
    break;
  case 20 : 
    filteredImg = composition.getBlendPhoenixImage(src, base, value); //pheonix
    break;
  case 21 : 
    filteredImg = composition.getBlendPinLightImage(src, base, value); //pin light
    break;
  case 22 : 
    filteredImg = composition.getBlendReflectImage(src, base, value); //reflect
    break;
  case 23 : 
    filteredImg = composition.getBlendSaturationImage(src, base, value); //saturation
    break;
  case 24 : 
    filteredImg = composition.getBlendScreenImage(src, base, value); //screen
    break;
  case 25 : 
    filteredImg = composition.getBlendSoftLightImage(src, base, value); //soft light
    break;
  case 26 : 
    filteredImg = composition.getBlendSubstractImage(src, base, value); //substract
    break;
  case 27 : 
    filteredImg = composition.getBlendVividLightImage(src, base, value); //vivid light
    break;
  }

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(base, imgw * 1, imgh * 0, imgw, imgh);
  image(filteredImg, imgw * 2, imgh * 0, imgw, imgh);

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

void keyPressed() {
  if (key == 'a') {
    count ++;
    if (count > blending.length - 1) {
      count = 0;
    }
  } else if (key == 'z') {
    count --;
    if (count < 0) {
      count = blending.length - 1;
    }
  }
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
