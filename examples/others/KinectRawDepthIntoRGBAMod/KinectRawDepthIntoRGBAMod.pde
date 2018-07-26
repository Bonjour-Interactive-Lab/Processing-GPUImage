/**
 * This example shows how to encode the kinect raw data values into an RGBA modulo texture
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
import KinectPV2.*;

KinectPV2 kinect;
IntPacking ip;
int dataLength;
int dataMax; //edge of the data
PImage rgbaMod;
PShader frag;
PGraphics buffer;

String[] name = {"Kinect depth256", "Encoded raw data into RGBA", "Graphics interpretation based on retrieved data"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  imgw = 512;
  imgh = 424;
  size(imgw * 3, imgh, P2D);
}


void setup() {

  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.init();
  dataMax = 8000; //the kinect raw data send value from 0 to 8000
  ip = new IntPacking(this);

  buffer = createGraphics(512, 424, P2D);
  ((PGraphicsOpenGL)buffer).textureSampling(2);
  buffer.hint(DISABLE_TEXTURE_MIPMAPS);
  frag = loadShader("frag.glsl");
}

void draw() {
  background(20);

  int [] data = kinect.getRawDepthData();

  for (int i = 0; i<data.length; i++) {
    if (data[i]>dataMax) {
      data[i] = dataMax;
    }
  }
  rgbaMod = ip.encodeARGB(data, dataMax);

  //decode data encoded into RGBA
  int[] rdata = ip.decodeARGB(rgbaMod, dataMax);
  double RMSE = getRMSE(data, rdata, dataMax);


  frag.set("dataTexture", rgbaMod);
  frag.set("dataMax", dataMax);
  frag.set("time", (float)millis() * 0.0001);
  buffer.beginDraw();
  buffer.shader(frag);
  buffer.rect(0, 0, buffer.width, buffer.height);
  buffer.endDraw();

  image(kinect.getDepth256Image(), imgw * 0, 0);
  image(rgbaMod, imgw * 1, 0);
  image(buffer, imgw * 2, 0);

  noStroke();
  fill(20);
  rect(0, 0, width, 60);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
    text(name[i], x * imgw + 20, y * imgh + 20);
  }
  text("RMSE: "+RMSE, imgw * 2 + 20, 40);

  showFPS();
}


double getRMSE(int[] data1, int[] data2, int dataMax) {
  //https://medium.com/human-in-a-machine-world/mae-and-rmse-which-metric-is-better-e60ac3bde13d
  float sum = 0.0;
  float n = 0.0;
  for (int i=0; i<data1.length && i<data2.length; i++) {
    float deviation = abs((float)data1[i] - (float)data2[i]);
    sum += (deviation * deviation);
    n ++;
  }
  float divider = 1.0 / n;
  float RMSE = sqrt(sum * divider);
  return RMSE/(float)dataMax;
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
