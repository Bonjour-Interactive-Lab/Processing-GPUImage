/**
 * This example shows how to encode a double value into an RGBA texture
 * 
 * This technic is usefull when you need to pass and array of values from CPU to GPU for vairous GPGPU computation on shader side — such as physics simulation on pixel analysis like optical flow — or if you need to send large amount of data as texture (using spout, syphon or NDI)
 * The main idea is to take a floating point value (double or float) on a range 0-1 and split/encode it into 16, 24 or 32 bits as color where :
 * 16 bits : the value is encoded into Red and Green (8 bits per channel). 255 * 255
 * 24 bits : the value is encoded into Red, Green and Blue (8 bits per channel). 255 * 255 * 255
 * 32 bits : the value is encoded into Red, Green, Blue and Alpha (8 bits per channel). 255 * 255 * 255 * 255
 * The more you split your value between the RGBA channels the more precision you will get when retrieving values
 *
 * You can also retreive values on GPU side (into shader). Please see the class documentation for glsl code or examples of GLSL simulation on the "other" folder
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import gpuimage.utils.*;

FloatPacking fp;
int dataLength;
float[] data;
PImage rgba32, rgba24, rgba16;
float[] data32, data24, data16;

String[] name = {"RGBA32 encoding", "RGBA24 encoding", "RGBA16 encoding"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  imgw = 1280;
  imgh = imgw / 3;
  size(imgw, imgh, P2D);
}


void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);

  //create a array of random value between 0 and 1
  dataLength = imgh * imgh;
  data = new float[dataLength];
  feedData(data);

  fp = new FloatPacking(this);
  rgba32 = fp.encodeARGB32Float(data);
  rgba24 = fp.encodeARGB24Float(data);
  rgba16 = fp.encodeARGB16Float(data);

  //decode data encoded into RGBA
  data32 = fp.decodeARGB32Float(rgba32);
  data24 = fp.decodeARGB24Float(rgba24);
  data16 = fp.decodeARGB16Float(rgba16);

  println("Number of encoded data: "+data.length);

  //compare the retieved data with the original data in order them and find the Root Mean Squared Error (RMSE)
  float RMSE32 = getRMSE(data, data32);
  float RMSE24 = getRMSE(data, data24);
  float RMSE16 = getRMSE(data, data16);
  println("RMSE on 32bits encoding: "+RMSE32+"\n"+
    "RMSE on 24bits encoding: "+RMSE24+"\n"+
    "RMSE on 16bits encoding: "+RMSE16);

}

void draw() {
  background(20);

  //Uncomment this lines to encode/decode at each loop.
  feedData(data);
  //Please note it's can be a expensive process to encode/decode GPU side. If you need to update the value it will be better to do it on a shader (GPU side)
  rgba32 = fp.encodeARGB32Float(data);
  //rgba24 = fp.encodeARGB24Float(data);
  //rgba16 = fp.encodeARGB16Float(data);

  //decode data encoded into RGBA
  data32 = fp.decodeARGB32Float(rgba32);
  //data24 = fp.decodeARGB24Float(rgba24);
  //data16 = fp.decodeARGB16Float(rgba16);

  image(rgba32, imgh * 0, 0, height, height);
  image(rgba24, imgh * 1, 0, height, height);
  image(rgba16, imgh * 2, 0, height, height);

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

void feedData(float[] data) {
  for (int i=0; i<data.length; i++) {
    data[i] = random(1.0);
  }
}

float getRMSE(float[] data1, float[] data2) {
  //https://medium.com/human-in-a-machine-world/mae-and-rmse-which-metric-is-better-e60ac3bde13d
  float sum = 0.0;
  float n = 0.0;
  for (int i=0; i<data1.length && i<data2.length; i++) {
    float deviation = Math.abs(data1[i] - data2[i]);
    sum += (deviation * deviation);
    n ++;
  }
  float divider = 1.0 / n;
  float RMSE = sqrt(sum * divider);
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
