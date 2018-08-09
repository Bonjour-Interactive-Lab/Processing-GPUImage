/**
 * This example shows how to encode the kinect raw data values into an RGBA modulo texture then decode it into the vertex shader in order to retreive World position point cloud.
 * All the vertex positions are compute into the vertex shader. See the sahders for more details.
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
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;
import peasy.*;

PeasyCam cam;
Kinect2 kinect;
IntPacking ip;
int dataLength;
int dataMax; //edge of the data
PImage rgbaMod;

PShader sh;
PShape pc;

String[] name = {"Kinect depth256", "Encoded raw data into RGBA"};

int nbFilter = 2;
float scale = 1.0;
int imgw, imgh;

void settings() {
  imgw = 512;
  imgh = 424;
  size(imgw * 2, imgh * 2, P3D);
}


void setup() {
  frameRate(300);

  //Init the camera in order to move into the scene
  cam = new PeasyCam(this, 0, 0, 0, 25);

  //Init the Kinect PV2 Object
  kinect = new Kinect2(this);

  kinect.initVideo();
  kinect.initDepth();
  kinect.initIR();
  kinect.initRegistered();
  kinect.initDevice();


  dataMax = 8000; //the kinect raw data send value from 0 to 8000
  ip = new IntPacking(this);//Init IntPacking

  sh = loadShader("frag.glsl", "vert.glsl");
  sh.set("dataMax", dataMax); //bind the max data size of the kinect
  sh.set("resolution", 512.0, 424.0); //bind the kinect infared resolution (depth resolution)
  sh.set("DepthIntrinsic", 259.31349, 197.22701, 361.2221, 361.85728); //bind the infared intrinsic parameter. You can find your own parameter by calibrating your camera. See more @MRPT calibration tutorial : https://www.mrpt.org/tutorials/programming/miscellaneous/kinect-calibration/ 

  //create a 512*424 point cloud grid
  pc = createShape();
  pc.beginShape(POINTS);
  pc.textureMode(NORMAL);
  pc.strokeWeight(1.0);
  for (int i=0; i<512*424; i++) {
    float x = i % 512;
    float y = (i - x) / 512;
    pc.stroke(255);
    pc.vertex(x, y, 0);
  }
  pc.endShape();
}

void draw() {
  background(20);

  int [] data = kinect.getRawDepth(); //grab the kinect depth raw data 
  /*
  //some data are outside the range, you can clamp it here
   for (int i = 0; i<data.length; i++) {
   if (data[i]>dataMax) {
   data[i] = dataMax;
   }
   }
   */
  //encode the data into an RGBAMod texture
  rgbaMod = ip.encodeARGB(data, dataMax);

  //bind the texture to the shader
  sh.set("dataTexture", rgbaMod);

  //apply shader and display point cloud
  shader(sh);
  shape(pc);

  //debug UI
  cam.beginHUD();
  float s = 0.45;
  float h = 60;
  noStroke();
  fill(20);
  rect(imgw * 0, imgh * 0 + h, imgw * s * 2, imgh * s);
  image(kinect.getDepthImage(), imgw * 0, imgh * 0 + h, imgw * s, imgh * s);
  image(rgbaMod, imgw * s, imgh * 0 + h, imgw * s, imgh * s);


  rect(0, 0, width, h);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
    text(name[i], x * imgw * s + 20, y * imgh * s + 20);
  }
  //decode data encoded into RGBA
  // int[] rdata = ip.decodeARGB(rgbaMod, dataMax);
  //double RMSE = getRMSE(data, rdata, dataMax);
  // text("RMSE: "+RMSE, imgw * 0 + 20, 40);

  showFPS(300);
  cam.endHUD();
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

void showFPS(int max) {
  int rfps = round(frameRate);
  float hueFPS = map(rfps, 0, max, 0, 120);
  pushStyle();
  colorMode(HSB, 360, 1.0, 1.0);
  fill(hueFPS, 1.0, 1.0);
  textAlign(RIGHT, CENTER);
  textSize(14);
  text("FPS : "+rfps, width - 20, 20); 
  popStyle();
}

void keyPressed() {
  save("GPUKinect.png");
}
