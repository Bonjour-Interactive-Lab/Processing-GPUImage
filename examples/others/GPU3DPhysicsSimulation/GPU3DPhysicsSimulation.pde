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

static final int VERT_CMP_COUNT = 3;
static final float RES = 1.0;//13.73;
FloatPacking fp;
PImage encodedPosBuffer, encodedVelBuffer, encodedMassBuffer, encodedMaxVelBuffer;
PingPongBuffer posBuffer, velBuffer;
PShader posFrag, velFrag;

float windx, windy, windz;
float xoff, yoff, zoff;
float worldWidth, worldHeight, worldDepth;
PShape particles;
PShader psh;


//debug
int WIDTH, HEIGHT;
int nbElement;
float[] originalData;
float[] decodedData;
float R=0.25, G=0.5, B=0.75;

void settings() {
  size(1280, 720, P3D);
}

void setup() {
  smooth(8);
  ((PGraphicsOpenGL)g).textureSampling(2);
  hint(DISABLE_TEXTURE_MIPMAPS);

  //load shaders for GPGPU simulation
  velFrag = loadShader("velFrag.glsl");
  posFrag = loadShader("posFrag.glsl");
  psh = loadShader("pfrag.glsl", "pvert.glsl");

  //create FloatPacking object 
  fp = new FloatPacking(this);
  worldWidth = worldHeight = worldDepth = 250.0;
  init(int(width/RES), int(height/RES));

  frameRate(300);

  cam = new PeasyCam(this, 0, 0, 0, 500);
  println(encodedPosBuffer.width, encodedPosBuffer.height, (encodedPosBuffer.width * encodedPosBuffer.height)/3.0);
}

void draw() {

  background(20);

  float minVel = 3.0;
  float maxVel = 6.0;
  float minMass = 4.0;
  float maxMass = 10.0;
  float len = 0.25;
  windx = noise(xoff, yoff, zoff) * 2.0 -1.0;
  windy = noise(yoff, zoff, xoff) * 2.0 -1.0;
  windz = noise(zoff, xoff, yoff) * 2.0 -1.0;
  windx *= len;
  windy *= len;
  windz *= len;
  xoff += 0.001;
  yoff += 0.0025;
  zoff += 0.0035;

  //update the vel and pos buffers
  posBuffer.swap(); //we swap buffer first in order to get the value;
  velBuffer.swap(); //we swap buffer first in order to get the value;


  //bind variables & buffers to the position buffer
  velFrag.set("bufferResolution", (float)posBuffer.dst.width, (float)posBuffer.dst.height);
  velFrag.set("worldResolution", worldWidth * 1.5, worldHeight * 1.5, worldDepth * 1.5);
  velFrag.set("posBuffer", posBuffer.getSrcBuffer());
  velFrag.set("maxVel", maxVel);
  velFrag.set("maxMass", maxMass);
  velFrag.set("wind", windx, windy, windz);
  //Update the vel buffer (using a ping pong buffer)
  /**
   * IMPORTANT : pre-multiply alpha is not supported on processing 3.X (based on 3.4)
   * Here we use a trick in order to render our image properly into our pingpong buffer
   * find out more here : https://github.com/processing/processing/issues/3391
   */
  velBuffer.dst.beginDraw(); 
  velBuffer.dst.clear();
  velBuffer.dst.blendMode(REPLACE);
  velBuffer.dst.shader(velFrag);
  velBuffer.dst.image(velBuffer.getSrcBuffer(), 0, 0);
  velBuffer.dst.endDraw();


  //bind variables & buffers to the position buffer
  posFrag.set("bufferResolution", (float)posBuffer.dst.width, (float)posBuffer.dst.height);
  posFrag.set("worldResolution", worldWidth * 1.5, worldHeight * 1.5, worldDepth * 1.5);
  posFrag.set("velBuffer", velBuffer.getSrcBuffer());
  posFrag.set("maxVel", maxVel);

  //Update the vel buffer (using a ping pong buffer)
  posBuffer.dst.beginDraw(); 
  posBuffer.dst.clear();
  posBuffer.dst.blendMode(REPLACE);
  posBuffer.dst.shader(posFrag);
  posBuffer.dst.image(posBuffer.getSrcBuffer(), 0, 0);
  posBuffer.dst.endDraw();

  //bind varibals to vertex shader
  psh.set("posBuffer", posBuffer.dst);

  shader(psh);
  shape(particles);  
  resetShader(POINTS);

  //debug display
  cam.beginHUD();
  float s = 0.05;
  float h = 40;
  fill(20);
  noStroke();
  rect(0, 0, width, h);
  rect(0, h, posBuffer.dst.width * s * 4, posBuffer.dst.height * s);
  image(posBuffer.getDstBuffer(), 0, h, posBuffer.dst.width * s, posBuffer.dst.height * s);
  image(velBuffer.getDstBuffer(), posBuffer.dst.width * s, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  image(encodedMassBuffer, posBuffer.dst.width * s * 2, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  image(encodedMaxVelBuffer, posBuffer.dst.width * s * 3, h, velBuffer.dst.width * s, velBuffer.dst.height * s);

  showFPS();
  //noLoop();
  cam.endHUD();
}

void init(int w, int h) {
  WIDTH = w;
  HEIGHT = h;
  nbElement = (w * h);
  originalData =  getPosData(w, h);
  float[] originalVelData = getVelData(w, h);
  float[] originalMassData = getRandData(w, h);
  float[] originalMaxVelData = getRandData(w, h);

  encodedPosBuffer = fp.encodeARGB24Float(originalData);
  encodedVelBuffer = fp.encodeARGB32Float(originalVelData);
  encodedMassBuffer = fp.encodeARGB24Float(originalMassData);
  encodedMaxVelBuffer = fp.encodeARGB24Float(originalMaxVelData);

  posBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height, P2D);
  velBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height, P2D);

  posBuffer.setFiltering(2);
  posBuffer.enableTextureMipmaps(false);
  posBuffer.dst.textureWrap(CLAMP);
  velBuffer.setFiltering(2);
  velBuffer.enableTextureMipmaps(false);
  velBuffer.dst.textureWrap(CLAMP);

  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);
  drawTextureIntoPingPongBuffer(velBuffer, encodedVelBuffer);


  posBuffer.dst.save("posBuffer.png");
  encodedPosBuffer.save("encodedPosBuffer.png");

  //debug
  decodedData = fp.decodeARGB24Float(encodedPosBuffer);

  //create shape
  particles = createShape();
  particles.beginShape(POINTS);
  particles.strokeWeight(1);
  for (int i=0; i<WIDTH*HEIGHT; i++) {
    float x = i % WIDTH;
    float y = (i - x) / WIDTH;
    float z = 0.0;

    float r = decodedData[i * VERT_CMP_COUNT + 0] * 255;
    float g = decodedData[i * VERT_CMP_COUNT + 1] * 255;
    float b = decodedData[i * VERT_CMP_COUNT + 2] * 255;

    particles.stroke(r, g, b);
    particles.vertex(x, y, 0);
  }
  particles.endShape();

  psh.set("gridResolution", (float) WIDTH, (float)HEIGHT);
  psh.set("bufferResolution", (float) encodedPosBuffer.width, (float)encodedPosBuffer.height);
  psh.set("worldResolution", worldWidth, worldHeight, worldDepth);
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
    
    float minr = 150.0;
    float maxr = 250.0;
    float r = minr + noise(phi * 3.0, sin(theta), sin((i/(float)nbParticles) * TWO_PI * 4.0)) * (maxr - minr);
    
    float x = sin(phi) * cos(theta) * r;
    float y = sin(phi) * sin(theta) * r;
    float z = cos(phi) * r;
    
    x = norm(x, -maxr, maxr);
    y = norm(y, -maxr, maxr);
    z = norm(z, -maxr, maxr);

    //we remap x,y,z from [-1, 1] to [0, 1] for encoding
    /*float ex = x * 0.5 + 0.5;
    float ey = y * 0.5 + 0.5;
    float ez = z * 0.5 + 0.5;*/

    // test step 2 : encode color
    posInterleavedPosData[i * VERT_CMP_COUNT + 0] = x;
    posInterleavedPosData[i * VERT_CMP_COUNT + 1] = y;
    posInterleavedPosData[i * VERT_CMP_COUNT + 2] = z;
  }

  return posInterleavedPosData;
}

float[] getVelData(int w, int h) {
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
  float[] velInterleavedPosData = new float[nbParticles * VERT_CMP_COUNT];
  for (int i=0; i<nbParticles; i++) {
    velInterleavedPosData[i * VERT_CMP_COUNT + 0] = 0.5;//random(1.0);
    velInterleavedPosData[i * VERT_CMP_COUNT + 1] = 0.5;//random(1.0);
    velInterleavedPosData[i * VERT_CMP_COUNT + 2] = 0.5;//random(1.0);
  }

  return velInterleavedPosData;
}

float[] getRandData(int w, int h) {
  final int nbParticles = w * h;
  float[] data = new float[nbParticles];
  for (int i=0; i<nbParticles; i++) {
    data[i] = random(1.0);
  }

  return data;
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

void keyPressed(){
  
  init(int(width/RES), int(height/RES));
}
