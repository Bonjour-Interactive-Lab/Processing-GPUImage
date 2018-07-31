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
static final float RES = 13.73;
FloatPacking fp;
PImage encodedPosBuffer;
PingPongBuffer posBuffer;

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
  //smooth(8);
  ((PGraphicsOpenGL)g).textureSampling(2);
  hint(DISABLE_TEXTURE_MIPMAPS);

  //load shaders for GPGPU simulation
  psh = loadShader("pfrag.glsl", "pvert.glsl");

  //create FloatPacking object 
  fp = new FloatPacking(this);

  init(int(width/RES), int(height/RES));

  frameRate(300);

  cam = new PeasyCam(this, WIDTH, HEIGHT/2, 0, 100);
  println(encodedPosBuffer.width, encodedPosBuffer.height);
}

void draw() {

  background(20);
  float s = 1.15;
  float h = 0;
  float w = 25;
  float l = 1;
  float mx = norm(mouseX, 10, width - 10);
  // float res = mx * (encodedPosBuffer.width * encodedPosBuffer.height);



  //debug display
  //cam.beginHUD();
  fill(R*255, G*255, B*255);
  noStroke();
  rect(0, 0, w, w);

  //debug original data
  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, w + l, WIDTH, w + l);
  noStroke();
  strokeWeight(4);
  for (int i=0; i<WIDTH*HEIGHT; i++) {
    float x = i % WIDTH;
    float y = (i - x) / WIDTH;

    float r_ = originalData[i * VERT_CMP_COUNT + 0] * 255;
    float g_ = originalData[i * VERT_CMP_COUNT + 1] * 255;
    float b_ = originalData[i * VERT_CMP_COUNT + 2] * 255;

    stroke(r_, g_, b_);
    point(x, w + l + l + y);
  }
  //display img encoded data 
  //tint(255, 127);
  image(encodedPosBuffer, WIDTH + encodedPosBuffer.width, w + l +l);

  //debug decoded data
  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, w + l + + l + HEIGHT, WIDTH, w + l + l + HEIGHT);
  noStroke();
  strokeWeight(4);
  for (int i=0; i<WIDTH*HEIGHT; i++) {
    float x = i % WIDTH;
    float y = (i - x) / WIDTH;

    float r_ = decodedData[i * VERT_CMP_COUNT + 0] * 255;
    float g_ = decodedData[i * VERT_CMP_COUNT + 1] * 255;
    float b_ = decodedData[i * VERT_CMP_COUNT + 2] * 255;

    stroke(r_, g_, b_);
    point(x, w + l + l + y + l + HEIGHT);
  }

  showFPS();
  
  
  

  //Bind varibales & buffers to the particles system shader
   psh.set("posBuffer", encodedPosBuffer);
  pushStyle();
  pushMatrix();
  translate(WIDTH, w + l + l);
  shader(psh);
  shape(particles);  
  resetShader(POINTS);
  popMatrix();
  popStyle();  
  
  
  //noLoop();
  //cam.endHUD();
}

void init(int w, int h) {
  WIDTH = w;
  HEIGHT = h;
  nbElement = (w * h);
  originalData = new float[nbElement * VERT_CMP_COUNT];

  for (int i=0; i<nbElement; i++) {
    originalData[i * VERT_CMP_COUNT + 0] = R;
    originalData[i * VERT_CMP_COUNT + 1] = G;
    originalData[i * VERT_CMP_COUNT + 2] = B;
  }

  encodedPosBuffer = fp.encodeARGB32Float(originalData);
  posBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height, P2D);
  posBuffer.setFiltering(2);
  posBuffer.enableTextureMipmaps(false);
  posBuffer.dst.textureWrap(CLAMP);
  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);

  //debug
  decodedData = fp.decodeARGB32Float(encodedPosBuffer);

  //create shape
  particles = createShape();
  particles.beginShape(POINTS);
  particles.strokeWeight(1);
  for (int i=0; i<WIDTH*HEIGHT; i++) {
    
    float x = i % WIDTH;
    float y = (i - x) / WIDTH;

    particles.stroke(204);
    particles.vertex(x, y);
  }
  particles.endShape();

  psh.set("gridResolution", (float) WIDTH, (float)HEIGHT);
  psh.set("bufferResolution", (float) encodedPosBuffer.width, (float)encodedPosBuffer.height);
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
