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

IntPacking ip;
int dataLength;
int dataMax; //edge of the data
int[] data;
PImage rgbaMod;
int[] dataMod;

String[] name = {"RGBAMod encoding"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  imgw = 512;
  imgh = imgw;
  size(imgw, imgh, P2D);
}


void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);

  //create a array of random value between 0 and 1
  dataLength = imgh * imgh;
  dataMax = 8000;
  data = new int[dataLength];
  feedData(data, dataMax, imgh, imgh, 0.0);

  ip = new IntPacking(this);
  rgbaMod = ip.encodeARGB(data, dataMax);

  //decode data encoded into RGBA
  dataMod = ip.decodeARGB(rgbaMod, dataMax);

  println("Number of encoded data: "+data.length);

  //compare the retieved data with the original data in order them and find the Root Mean Squared Error (RMSE)
  float RMSE = (float) getRMSE(data, dataMod, dataMax);
  println("RMSE on RGBAMod encoding: "+RMSE);
}

void draw() {
  background(20);

  //Uncomment this lines to encode/decode at each loop.
  //feedData(data, 4500, 512, 424, millis() * 0.001);
  
  //Please note it's can be a expensive process to encode/decode GPU side. If you need to update the value it will be better to do it on a shader (GPU side)
  //rgbaMod = ip.encodeARGB(data, dataMax);

  //decode data encoded into RGBA
  //dataMod = ip.decodeARGB(rgbaMod, dataMax);

  image(rgbaMod, imgh * 0, 0, height, height);

  noStroke();
  fill(20);
  rect(0, 0, width, 40);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
    text(name[i], x * imgh + 20, y * imgh + 20);
  }

  showFPS();
}

void feedData(int[] datas, int dataMax, int w, int h, float counter) {
  PVector center = new PVector(w/2, h/2);
  float hyp = sqrt(w * w + h + h);
  for (int i=0; i<datas.length; i++) {
    float x = i % w;
    float y = (i - x) / w;
    PVector loc = new PVector(x, y);
    PVector toCenter = PVector.sub(center, loc);
    float normDepth = (toCenter.mag() + noise(x * 0.1 + counter, y * 0.1 + counter, counter) * w/10) / hyp;
    //normDepth *= 10.0;
    //normDepth %= 1.0;
    datas[i] = int(normDepth * dataMax);
  }
}

double getRMSE(int[] data1, int[] data2, int dataMax) {
  //https://medium.com/human-in-a-machine-world/mae-and-rmse-which-metric-is-better-e60ac3bde13d
  double sum = 0.0;
  double n = 0.0;
  for (int i=0; i<data1.length && i<data2.length; i++) {
    double deviation = Math.abs((double)data1[i]/(double)dataMax - (double)data2[i]/(double)dataMax);
    sum += (deviation * deviation);
    n ++;
  }
  double divider = 1.0 / n;
  double RMSE = Math.sqrt(sum * divider);
  return RMSE;
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
