/**
 * This example shows how to encode a int value into an RGBA modulo texture
 * 
 * This technic is usefull when you need to pass and integer array of values from CPU to GPU for vairous GPGPU computation on shader side — such as physics simulation on pixel analysis like optical flow — or if you need to send large amount of data as texture (using spout, syphon or NDI)
 * This class provide a faster encoding/decoding methods than the FloatPacking by using only modulo and alpha channel. Howerver this cannot be use for non integer value.
 * The main idea is to take a integer value from a range of 0 to KNOWN value and split it across a the RG channel by using a value%255.
 * The index of the modulo (number of repetition across the range) is store into the blue channel
 *
 * You can also retreive values on GPU side (into shader). Please see the class documentation for glsl code or examples of GLSL simulation on the "other" folder
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import gpuimage.utils.*;


Vec2Packing vp;

PVector[] data;
PImage encodedImage;
PVector[] rdata;

String[] name = {"Raw data", "Decoded data"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  imgw = 512;
  imgh = imgw;
  size(imgw * 2, imgh, P2D);
}


void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);
  
  //create a array of random value between 0 and 1
  data = new PVector[1000];
  feedData(data, 0.0);

  vp = new Vec2Packing(this);

  encodedImage = vp.encodeARGB(data);

  //decode data encoded into RGBA
  rdata = vp.decodeARGB(encodedImage);

  println("Number of encoded data: "+data.length);

  //compare the retieved data with the original data in order them and find the Root Mean Squared Error (RMSE)
  float RMSE = (float) getRMSE(data, rdata);
  println("RMSE encoding: "+RMSE);
  
  frameRate(300);
  background(20, 0);
}

void draw() {
  //background(20, 0);
  fill(20, 50);
  noStroke();
  rect(0, 0, width, height);

  feedData(data, frameCount * 0.001);
  
  //Please note it's can be a expensive process to encode/decode GPU side. If you need to update the value it will be better to do it on a shader (GPU side)
  encodedImage = vp.encodeARGB(data);

  //decode data encoded into RGBA
  rdata = vp.decodeARGB(encodedImage);
  
  //compare the retieved data with the original data in order them and find the Root Mean Squared Error (RMSE)
  float RMSE = (float)getRMSE(data, rdata);
  
  // Draw original and decoded datas 
  stroke(255);
  for (int i=0; i<rdata.length; i++) {
    PVector ov = data[i];
    PVector rv = rdata[i];

    point(ov.x * width/2, ov.y * height);

    point(rv.x * width/2 + width/2, rv.y * height);
  }
  
  float iscale = 2.0;
  image(encodedImage, imgh * 0, 60, encodedImage.width * iscale, encodedImage.height * iscale);

  noStroke();
  fill(20);
  rect(0, 0, width, 60);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
    text(name[i], x * imgh + 20, y * imgh + 20);
  }
  text("RMSE : "+RMSE, imgh + 20, 40);

  showFPS();
}

void feedData(PVector[] datas, float counter) {
  float w = sqrt(datas.length);
  float inci = 0.005;
  for (int i=0; i<datas.length; i++) {
    float x = i % w;
    float y = (i - x) / w;
    float nx = noise(x/w + counter - i * inci, y/w - counter + i * inci, counter);
    float ny = noise(y/w - counter + i * inci, x/w + counter - i * inci, counter);
    datas[i] = new PVector(nx, ny);
  }
}

double getRMSE(PVector[] data1, PVector[] data2) {
  //https://medium.com/human-in-a-machine-world/mae-and-rmse-which-metric-is-better-e60ac3bde13d
  double sum = 0.0;
  double n = 0.0;
  for (int i=0; i<data1.length && i<data2.length; i++) {

    double deviation = PVector.dist(data1[i], data2[i]);
    sum += (deviation * deviation);
    n ++;
  }
  double divider = 1.0 / n;
  double RMSE = Math.sqrt(sum * divider);
  return RMSE;
}

void showFPS() {
  int rfps = round(frameRate);
  float hueFPS = map(rfps, 0, 300, 0, 120);
  pushStyle();
  colorMode(HSB, 360, 1.0, 1.0);
  fill(hueFPS, 1.0, 1.0);
  textAlign(RIGHT, CENTER);
  textSize(14);
  text("FPS : "+rfps, width - 20, 20); 
  popStyle();
}
