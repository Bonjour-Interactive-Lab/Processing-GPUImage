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
  
  switch(count) {
  case 0 : 
    composition.getBlendAdd(src, base, value); //add
    break;
  case 1 : 
    composition.getBlendAverage(src, base, value); //average
    break;
  case 2 : 
    composition.getBlendColorBurn(src, base, value); //color burn
    break;
  case 3 : 
    composition.getBlendColorDodge(src, base, value); //color dodge
    break;
  case 4 : 
    composition.getBlendColor(src, base, value); //color
    break;
  case 5 : 
    composition.getBlendDarken(src, base, value); //darken
    break;
  case 6 : 
    composition.getBlendDifference(src, base, value); //difference
    break;
  case 7 : 
    composition.getBlendExclusion(src, base, value); //exclusion
    break;
  case 8 : 
    composition.getBlendGlow(src, base, value); //glow
    break;
  case 9 : 
    composition.getBlendHardLight(src, base, value); //hard light
    break;
  case 10 : 
    composition.getBlendHardMix(src, base, value); //hard mix
    break;
  case 11 : 
    composition.getBlendHue(src, base, value); //hue
    break;
  case 12 : 
    composition.getBlendLighten(src, base, value); //lighten
    break;
  case 13 : 
    composition.getBlendLinearBurn(src, base, value); //linear burn
    break;
  case 14 : 
    composition.getBlendLinearDodge(src, base, value); //linear dodge
    break;
  case 15 : 
    composition.getBlendLinearLight(src, base, value); //linear light
    break;
  case 16 : 
    composition.getBlendLuminosity(src, base, value); //luminosity
    break;
  case 17 : 
    composition.getBlendMultiply(src, base, value); //multiply
    break;
  case 18 : 
    composition.getBlendNegation(src, base, value); //negation
    break;
  case 19 : 
    composition.getBlendOverlay(src, base, value); //overlay
    break;
  case 20 : 
    composition.getBlendPhoenix(src, base, value); //pheonix
    break;
  case 21 : 
    composition.getBlendPinLight(src, base, value); //pin light
    break;
  case 22 : 
    composition.getBlendReflect(src, base, value); //reflect
    break;
  case 23 : 
    composition.getBlendSaturation(src, base, value); //saturation
    break;
  case 24 : 
    composition.getBlendScreen(src, base, value); //screen
    break;
  case 25 : 
    composition.getBlendSoftLight(src, base, value); //soft light
    break;
  case 26 : 
    composition.getBlendSubstract(src, base, value); //substract
    break;
  case 27 : 
    composition.getBlendVividLight(src, base, value); //vivid light
    break;
  }

  image(src, imgw * 0, imgh * 0, imgw, imgh);
  image(base, imgw * 1, imgh * 0, imgw, imgh);
  image(composition.getBuffer(), imgw * 2, imgh * 0, imgw, imgh);

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
