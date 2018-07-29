/**
 * This example shows how to use FloatPacking in order to create a full GPU 3D particles physics system
 * See shaders code for more detail on GPU side
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */

import gpuimage.core.*;
import gpuimage.utils.*;
import peasy.*;

PeasyCam cam;

float res = 1.5;
int VERT_CMP_COUNT;
FloatPacking fp;
PImage encodedPosBuffer, encodedVelBuffer, encodedMassBuffer, encodedMaxVelBuffer;
PingPongBuffer posBuffer, velBuffer;
PShader posFrag, velFrag;

PShape particles;
PShader psh;

//World variables
float worldWidth, wolrdHeight, worldDepth;

//debug display
String[] name = {"Position Buffer", "Velocity Buffer", "Mass buffer", "Max Velocity buffer"};

void settings() {
  size(1280, 720, P3D);
}

void setup() {
  smooth(8);
  ((PGraphicsOpenGL)g).textureSampling(3);

  cam = new PeasyCam(this, 0, 0, 0, 500);

  //load shaders for GPGPU simulation
  //posFrag = loadShader("posFrag.glsl");
  //velFrag = loadShader("velFrag.glsl");
  psh = loadShader("pfrag.glsl", "pvert.glsl");

  //create FloatPacking object 
  fp = new FloatPacking(this);

  init(int(width/res), int(height/res));

  frameRate(300);
  println("Scene has: "+(encodedPosBuffer.width * encodedPosBuffer.height)/ VERT_CMP_COUNT+" particles");
  println("Scene has: "+(encodedPosBuffer.width/ VERT_CMP_COUNT * encodedPosBuffer.height)+" particles");
  println("Buffer res: "+encodedPosBuffer.width+"×"+encodedPosBuffer.height);

  encodedPosBuffer.save("test.png");
}

void draw() {
  background(20);

  //Bind varibales & buffers to the particles system shader
  psh.set("posBuffer", encodedPosBuffer);

  shader(psh);
  shape(particles);
  resetShader();

  //debug display
  cam.beginHUD();
  float s = 0.15;
  float h = 40;
  fill(0);
  noStroke();
  rect(0, h, posBuffer.dst.width * s * 4, posBuffer.dst.height * s);
  image(posBuffer.getDstBuffer(), 0, h, posBuffer.dst.width * s, posBuffer.dst.height * s);
  // image(velBuffer.getDstBuffer(), posBuffer.dst.width * s, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  //image(encodedMassBuffer, posBuffer.dst.width * s * 2, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  //image(encodedMaxVelBuffer, posBuffer.dst.width * s * 3, h, velBuffer.dst.width * s, velBuffer.dst.height * s);

  noStroke();
  fill(20);
  rect(0, 0, width, h);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 4;
    int y = (i-x) / 4;
    //text(name[i], x * posBuffer.dst.width *s + 10, y * height + 20);
  }
  textAlign(RIGHT, CENTER);
  text("Number of particles: "+ (posBuffer.dst.width * posBuffer.dst.height) / VERT_CMP_COUNT, width - 140, 20);
  showFPS();
  //noLoop();
  cam.endHUD();
}

void init(int w, int h) {
  VERT_CMP_COUNT = 3;
  //create a array of random value between 0 and 1
  float[] firstPosData = getPosData(w, h);

  //encode data into texture
  encodedPosBuffer= fp.encodeARGB32Float(firstPosData);

  //Create two ping pong buffer (one for each pos and vel buffer)
  posBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height, P2D);
  //velBuffer = new PingPongBuffer(this, encodedVelBuffer.width, encodedVelBuffer.height, P2D);
  //set the filtering
  posBuffer.setFiltering(3);
  posBuffer.enableTextureMipmaps(false);
  //velBuffer.setFiltering(3);
  //velBuffer.enableTextureMipmaps(false);


  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);
  //drawTextureIntoPingPongBuffer(velBuffer, encodedVelBuffer);

  //float[] data = fp.decodeARGB32Float(encodedPosBuffer);
  //create grid of particles
  int nbParticles = firstPosData.length / VERT_CMP_COUNT;
  particles = createShape();
  particles.beginShape(POINTS);
  particles.strokeWeight(2);
  particles.stroke(255);
  for (int i=0; i<nbParticles; i++) {
    float pindex = i * VERT_CMP_COUNT;
   // println(i, pindex);
    float x = pindex % encodedPosBuffer.width;
    float y = (pindex - x) / encodedPosBuffer.width;
    //decomment this lines if you want to see the color of each particle as its index
    double normi =(double)i / (double)nbParticles;
    int indexColor = fp.doubleToARGB32(normi);
    particles.stroke(indexColor);
    //particles.stroke(0.0, random(255), random(255));
    particles.vertex(x, y, 0);
    /*
    int pindex_ = floor(x + y * encodedPosBuffer.width);
     int i_ = pindex_/3;
     */
    /* float x_ = (data[i * VERT_CMP_COUNT + 0] * 2.0 - 1.0) * 250;
     float y_ = (data[i * VERT_CMP_COUNT + 1] * 2.0 - 1.0) * 250;
     float z_ = (data[i * VERT_CMP_COUNT + 2] * 2.0 - 1.0) * 250;
     particles.vertex(x_, y_, z_);*/
  }
  particles.endShape();
  psh.set("worldResolution", 1000.0, 1000.0, 1000.0);
  psh.set("bufferResolution", (float)encodedPosBuffer.width, (float)encodedPosBuffer.height);
}

float[] getPosData(int w, int h) {
  /**
   * define layout for interleaved VBO
   * xyzwrgbaxyzwrgbaxyzwrgba...
   * 
   * |v1 |v2 |v3 |v4 |...
   * |0  |3  |6  |9  |...
   * |xyz|xyz|xyz|xyz|..
   * 
   * stride (values per vertex) is 3 floats
   * vertex offset is 3 floats (starts at the beginning of each line)
   * 
   * vi | offset |values
   * 0  | 0      |xyz
   * 2  | 3      |xyz
   * 3  | 6      |xyz
   * ...|...     |... 
   */
  final int nbParticles = w * h;
  float[] posInterleavedPosData = new float[nbParticles * VERT_CMP_COUNT];
  /**
   * Spherical coordinates given by : https://en.wikipedia.org/wiki/Spherical_coordinate_system
   * x = R * sin(phi) * cos(theta)
   * y = R * sin(phi) * sin(theta)
   * z = R * cos(phi)
   * where 0<phi<PI & 0<theta<TWO_PI
   * phi : longitude, theta : latitude
   * Here R = 1.0 because wa need value from 0 to one;
   */
  for (int i=0; i<nbParticles; i++) {
    float cx = i % w;
    float cy = (i - cx) / w;
    float u = cx / (float) w;
    float v = cy / (float) h;

    float phi = u * PI;
    float theta = v * TWO_PI;

    float x = sin(phi) * cos(theta);
    float y = sin(phi) * sin(theta);
    float z = cos(phi);

    //we remap x,y,z from [-1, 1] to [0, 1] for encoding
    float ex = x * 0.5 + 0.5;
    float ey = y * 0.5 + 0.5;
    float ez = z * 0.5 + 0.5;

    posInterleavedPosData[i * VERT_CMP_COUNT + 0] = ex;
    posInterleavedPosData[i * VERT_CMP_COUNT + 1] = ey;
    posInterleavedPosData[i * VERT_CMP_COUNT + 2] = ez;
  }

  return posInterleavedPosData;
}

void drawTextureIntoPingPongBuffer(PingPongBuffer ppb, PImage tex) { 
  /**
   * IMPORTANT : pre-multiply alpha is not supported on processing 3.X (based on 3.4)
   * Here we use a trick in order to render our image properly into our pingpong buffer
   * find out more here : https://github.com/processing/processing/issues/3391
   */
  ppb.dst.beginDraw(); 
  ppb.dst.clear();
  ppb.dst.blendMode(REPLACE);
  ppb.dst.image(tex, 0, 0, ppb.dst.width, ppb.dst.height);
  ppb.dst.endDraw();
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
