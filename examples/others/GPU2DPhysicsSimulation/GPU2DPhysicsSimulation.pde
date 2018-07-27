/**
 * This example shows how to us Vec2Packing in order to create a full GPU particle physics
 * Based on Chris Wellons article : https://nullprogram.com/blog/2014/06/29/
 
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */
import gpuimage.core.*;
import gpuimage.utils.*;


Vec2Packing vp;
PImage encodedPosBuffer, encodedVelBuffer;
PingPongBuffer posBuffer, velBuffer, massBuffer;
PShader posFrag;
VBOInterleaved vbo;

PShape particles;
PShader psh;

String[] name = {"Raw data", "Decoded data"};

float scale = 1.0;
int imgw, imgh;

void settings() {
  imgw = 1280;
  imgh = 720;
  size(imgw, imgh, P3D);
  PJOGL.profile = 4;
}


void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);

  posFrag = loadShader("posFrag.glsl");

  //create a array of random value between 0 and 1
  PVector[] firstPosData = getRandomData(width/2, height/2);
  PVector[] firstVelData = getRandomData(width/2, height/2);

  //encode the data into texture
  vp = new Vec2Packing(this);
  encodedPosBuffer = vp.encodeARGB(firstPosData);
  encodedVelBuffer = vp.encodeARGB(firstVelData);

  //add the texture to the PinPongBuffer
  posBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height);
  velBuffer = new PingPongBuffer(this, encodedVelBuffer.width, encodedVelBuffer.height);
  posBuffer.setFiltering(2);
  posBuffer.enableTextureMipmaps(false);

  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);
  drawTextureIntoPingPongBuffer(velBuffer, encodedVelBuffer);

  posBuffer.dst.save("posBuffer.png");
  encodedPosBuffer.save("encodedPosBuffer.png");
/*
  ArrayList<Float> attribList = new ArrayList<Float>();
  for (int i=0; i<firstPosData.length; i++) {
    float x = i % encodedPosBuffer.width;
    float y = (i - x) / encodedPosBuffer.width;
    float u = x / (float) encodedPosBuffer.width;
    float v = y / (float) encodedPosBuffer.height;

    attribList.add(x);
    attribList.add(y);
    attribList.add(0.0);
    attribList.add(1.0);

    attribList.add(1.0);
    attribList.add(1.0);
    attribList.add(1.0);
    attribList.add(1.0);

    attribList.add(u);
    attribList.add(v);
    attribList.add(0.0);
    attribList.add(0.0);
  }

  vbo = new VBOInterleaved(g, attribList);
*/
  particles = createShape();

  particles.beginShape(POINTS);
  particles.textureMode(NORMAL);
  for (int i=0; i<firstPosData.length; i++) {
    float x = i % encodedPosBuffer.width;
    float y = (i - x) / encodedPosBuffer.width;
    float u = x / (float) encodedPosBuffer.width;
    float v = y / (float) encodedPosBuffer.height;
    particles.stroke(u * 255, v * 255, 0.0);
    particles.vertex(x, y, u, v);
  }
  particles.endShape();

  psh = loadShader("pfrag.glsl", "pvert_2.glsl");
  psh.set("dataTexResolution", float(encodedPosBuffer.width), float(encodedPosBuffer.height));

  //compare the retieved data with the original data in order them and find the Root Mean Squared Error (RMSE)
  //float RMSE = (float) getRMSE(firstPosData, firstVelData);
  //println("RMSE encoding: "+RMSE);

  frameRate(300);
}

void draw() {
  background(20);


  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);

  //vbo.display(encodedPosBuffer);
  
  psh.set("dataTexture", encodedPosBuffer);
  shader(psh);
  shape(particles);

  float s = 0.5;
  float h = 60;
  image(posBuffer.getDstBuffer(), 0, h, posBuffer.dst.width * s, posBuffer.dst.height * s);
  image(encodedPosBuffer, posBuffer.dst.width * s, h, velBuffer.dst.width * s, velBuffer.dst.height * s);
  //image(velBuffer.getDstBuffer(), posBuffer.dst.width * s, h, velBuffer.dst.width * s, velBuffer.dst.height * s);

  noStroke();
  fill(20);
  rect(0, 0, width, h);
  fill(240);
  textAlign(LEFT, CENTER);
  textSize(14);
  for (int i=0; i<name.length; i++) {
    int x = i % 3;
    int y = (i-x) / 3;
    text(name[i], x * imgh + 20, y * imgh + 20);
  }
  //compare the retieved data with the original data in order them and find the Root Mean Squared Error (RMSE)
  //float RMSE = (float)getRMSE(data, rdata);
  //text("RMSE : "+RMSE, imgh + 20, 40);

  showFPS();

  //posBuffer.swap();
}

void drawTextureIntoPingPongBuffer(PingPongBuffer ppb, PImage tex) { 
  ppb.dst.beginDraw(); 
  ppb.dst.clear();
  ppb.dst.background(204, 1);
  ppb.dst.shader(posFrag);
  ppb.dst.image(tex, 0, 0, ppb.dst.width, ppb.dst.height);
  ppb.dst.endDraw();
}

PVector[] getRandomData(int w, int h) {
  PVector[] data = new PVector[w*h];
  for (int i=0; i<data.length; i++) {
    float t = norm(i, 0, data.length) * TWO_PI;
    float r = (height * 0.25);
    float nx = width/2 + cos(t) * r;
    float ny = height/2 + sin(t) * r;
    data[i] = new PVector(nx / (float)width, ny/(float)height);
  }

  return data;
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
  float hueFPS = map(rfps, 0, 60, 0, 120);
  pushStyle();
  colorMode(HSB, 360, 1.0, 1.0);
  fill(hueFPS, 1.0, 1.0);
  textAlign(RIGHT, CENTER);
  textSize(14);
  text("FPS : "+rfps, width - 20, 20); 
  popStyle();
}
