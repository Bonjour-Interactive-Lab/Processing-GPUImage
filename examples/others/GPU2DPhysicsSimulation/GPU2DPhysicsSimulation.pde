/**
 * This example shows how to use Vec2Packing in order to create a full GPU 2D particles physics system
 * Based on Chris Wellons article : https://nullprogram.com/blog/2014/06/29/
 * See shaders code for more detail on GPU side
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import gpuimage.utils.*;

float res = 1.5;
Vec2Packing vp;
FloatPacking fp;
PImage encodedPosBuffer, encodedVelBuffer, encodedMassBuffer, encodedMaxVelBuffer;
PingPongBuffer posBuffer, velBuffer;
PShader posFrag, velFrag;

float windx;
float xoff, yoff, zoff;
PShape particles;
PShader psh;

String[] name = {"Position Buffer", "Velocity Buffer", "Mass buffer", "Max Velocity buffer"};

void settings() {
  //we use the P3D capabilities even if th particle system is 2D based
  size(1280, 720, P3D);
}


void setup() {
  smooth(8);
  ((PGraphicsOpenGL)g).textureSampling(3);

  //load shaders for GPGPU simulation
  posFrag = loadShader("posFrag.glsl");
  velFrag = loadShader("velFrag.glsl");
  psh = loadShader("pfrag.glsl", "pvert.glsl");

  //create Vec2packing and FloatPacking object 
  vp = new Vec2Packing(this);
  fp = new FloatPacking(this);

  init(int(width/res), int(height/res));

  frameRate(300);
  println("Scene has: "+int(width/res * height/res)+" particles");
  println("Buffer res: "+encodedPosBuffer.width+"×"+encodedPosBuffer.height);
  
  //noCursor();
  
}

void draw() { 
  //modulo timer to reset the particle system every X frames
  if (frameCount % (300 * 4) == 0) {
    init(int(width/res), int(height/res));
  }

  background(20);
  /*fill(20, 10);
  noStroke();
  rect(0, 0, width, height);*/
  
  //set the obstacle position (mx, my)
  float maxtime = 300 * 1.5;
  float gamma = (frameCount % maxtime) / maxtime;
  float mouseSize = 75.0;
  float radius = height/2 * 0.95;
  float mx = width/2 + cos(-HALF_PI + gamma * TWO_PI) * radius;
  float my = height/2 + sin(-HALF_PI + gamma * TWO_PI) * radius;
  
  //set the particles system variable (speed, force...)
  float minVel = 3.0;
  float maxVel = 6.0;
  float minMass = 4.0;
  float maxMass = 10.0;
  float len = 0.25;
  windx = noise(xoff, yoff, zoff) * 2.0 -1.0;
  windx *= len;
  xoff += 0.001;
  yoff += 0.0025;
  zoff += 0.0035;
  
  //display the obstacle
  stroke(50);
  line(width/2, height/2, mx, my);
  noStroke();
  fill(50);
  ellipse(mx, my, mouseSize, mouseSize);
  stroke(255, 255, 0);
  line(width/2.0, height/2, width/2 + windx * 150, height/2);
  
  //update the vel and pos buffers
  posBuffer.swap(); //we swap buffer first in order to get the value;
  velBuffer.swap(); //we swap buffer first in order to get the value;
  
  //bind variables & buffers to the vel buffer
  velFrag.set("posBuffer", posBuffer.getSrcBuffer());
  velFrag.set("worldResolution", (float) width, (float) height);
  velFrag.set("massBuffer", encodedMassBuffer);
  velFrag.set("maxVelBuffer", encodedMaxVelBuffer);
  velFrag.set("maxMass", maxMass);
  velFrag.set("minMass", minMass);
  velFrag.set("minVel", minVel);
  velFrag.set("maxVel", maxVel);
  velFrag.set("wind", windx, 0.0);
  velFrag.set("mouse", mx, my);
  velFrag.set("mouseSize", mouseSize);
  
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
  posFrag.set("velBuffer", velBuffer.getSrcBuffer());
  posFrag.set("maxVelBuffer", encodedMaxVelBuffer);
  posFrag.set("worldResolution", (float) width, (float) height);
  posFrag.set("minVel", minVel);
  posFrag.set("maxVel", maxVel);
  posFrag.set("mouse", mx, my);
  posFrag.set("mouseSize", mouseSize);

  //Update the vel buffer (using a ping pong buffer)
  posBuffer.dst.beginDraw(); 
  posBuffer.dst.clear();
  posBuffer.dst.blendMode(REPLACE);
  posBuffer.dst.shader(posFrag);
  posBuffer.dst.image(posBuffer.getSrcBuffer(), 0, 0);
  posBuffer.dst.endDraw();
  
  //Bind varibales & buffers to the particles system shader
  psh.set("posBuffer", posBuffer.dst);
  psh.set("massBuffer", encodedMassBuffer);
  psh.set("maxMass", maxMass * 0.5);
  psh.set("minMass", minMass * 0.5);

  //display the particles system
  shader(psh);
  shape(particles);
  resetShader();
  
  //debug display
  float s = 0.15;
  float h = 40;
  fill(204);
  noStroke();
  rect(0, h,  posBuffer.dst.width * s * 4,  posBuffer.dst.height * s);
  image(posBuffer.getDstBuffer(), 0, h, posBuffer.dst.width * s, posBuffer.dst.height * s);
  image(velBuffer.getDstBuffer(), posBuffer.dst.width * s, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  image(encodedMassBuffer, posBuffer.dst.width * s * 2, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  image(encodedMaxVelBuffer, posBuffer.dst.width * s * 3, h, velBuffer.dst.width * s, velBuffer.dst.height * s);

  noStroke();
  fill(20);
  rect(0, 0, width, h);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 4;
    int y = (i-x) / 4;
    text(name[i], x * posBuffer.dst.width *s + 10, y * height + 20);
  }
  textAlign(RIGHT, CENTER);
  text("Number of particles: "+ posBuffer.dst.width * posBuffer.dst.height, width - 140, 20);
  textAlign(RIGHT, TOP);
  text(GPUImage.GPUINFO.getGpuInfos(),  width - 140, 40);
  showFPS();
  //noLoop();
}

void keyPressed() {
  init(int(width/res), int(height/res));
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

void init(int w, int h) {
  //create a array of random value between 0 and 1
  PVector[] firstPosData = getRandomData(w, h, (int)random(4, 12));
  PVector[] firstVelData = getVelData(w, h);
  float[] massData = getMassData(w, h);
  float[] maxVelData = getMassData(w, h);
  encodedPosBuffer = vp.encodeARGB(firstPosData);
  encodedVelBuffer = vp.encodeARGB(firstVelData);
  encodedMassBuffer = fp.encodeARGB32Float(massData);
  encodedMaxVelBuffer = fp.encodeARGB32Float(maxVelData);

  //Create two ping pong buffer (one for each pos and vel buffer)
  posBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height, P2D);
  velBuffer = new PingPongBuffer(this, encodedVelBuffer.width, encodedVelBuffer.height, P2D);
  //set the filtering
  posBuffer.setFiltering(3);
  posBuffer.enableTextureMipmaps(false);
  velBuffer.setFiltering(3);
  velBuffer.enableTextureMipmaps(false);

  drawTextureIntoPingPongBuffer(velBuffer, encodedVelBuffer);
  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);

  //create grid of particles
  particles = createShape();
  particles.beginShape(POINTS);
  particles.strokeWeight(1);
  for (int i=0; i<firstPosData.length; i++) {
    float x = i % encodedPosBuffer.width;
    float y = (i - x) / encodedPosBuffer.width;
    //decomment this lines if you want to see the color of each particle as its index
    double normi =(double)i / (double)firstPosData.length;
    int indexColor = vp.doubleToARGB32(normi);
    particles.stroke(indexColor);
    //particles.stroke(0.0, random(255), random(255));
    particles.vertex(x, y);
  }
  particles.endShape();

  //set the variable to the particles shader
  psh.set("worldResolution", (float)width, (float)height);
  psh.set("bufferResolution", (float)encodedPosBuffer.width, (float)encodedPosBuffer.height);
}

PVector[] getRandomData(int w, int h, int loopPI) {
  PVector[] data = new PVector[w*h];
  float midRadius = height * 0.25;
  float minRadius = height * 0.05;
  for (int i=0; i<data.length; i++) {
    float x = i % w;
    float y = (i - x) / (float)h;

    float t = norm(i, 0, data.length) * TWO_PI;
    float noised = noise(x * 0.001, y * 0.001, i*0.001);
    //float noiseSwitch = noised * 2.0 - 1.0;
    float r = midRadius + noised * minRadius + sin(t * loopPI) * (midRadius * noised) + random(-1, 1) * minRadius;
    float nx = width/2 + cos(t) * r;
    float ny = height/2 + sin(t) * r;
    //nx = random(width);
    //ny = random(height);
    data[i] = new PVector(nx / (float)width, ny/(float)height);
  }

  return data;
}

PVector[] getVelData(int w, int h) {
  PVector[] data = new PVector[w*h];
  for (int i=0; i<data.length; i++) {
    data[i] = new PVector(0.5, 0.5);
  }

  return data;
}

float[] getMassData(int w, int h) {
  float[] data = new float[w*h];
  for (int i=0; i<data.length; i++) {
    float nm = random(1.0);
    data[i] = nm;
  }

  return data;
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
