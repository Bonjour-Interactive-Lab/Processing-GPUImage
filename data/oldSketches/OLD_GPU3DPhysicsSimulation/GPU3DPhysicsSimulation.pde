/**
 * NOTE : using an interleaved texture will be not as usefull as an interleaved VBO
 * It will be to much computation on shader side in order to retreive the XYZ
 * Se we need to use a colum/row prior texture -> see older GPGPU implementation for more informations
 */


/**
 * This example shows how to use FloatPacking in order to create a full GPU 3D particles physics system
 * See shaders code for more detail on GPU side
 
 Encoding X, Y, Z into a single RGB textures divid by row then decoding it into a interleaved Vertex Buffer Object
 Use a single texture to encore velocity per particles
 Use GLSL to decoce velocity and update it according to various external force methods such as gravity, wind, friction
 Use GLSL to decode velocity and position then update position according to velocity (location += velocity)
 Use GLSL to decode position into the vertyex shader of the VBO then update the vertex position into the GPU
 - Update position on the VBO is GPU side 
 - Texture is set by rows and decoding into GLSL custoom shader
 **********
 *        *
 *    Z   *
 *        *
 **********
 *        *
 *    Y   *
 *        *
 **********
 *        *
 *    X   *
 *        *
 **********
 
 * --
 * Bonjour Lab.
 * http://www.bonjour-lab.com
 */

import gpuimage.core.*;
import gpuimage.utils.*;
import peasy.*;

PeasyCam cam;

static final int VERT_CMP_COUNT = 3;
static final float RES = 1.0;
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

  cam = new PeasyCam(this, 0, 0, 0, 100);
  println(WIDTH, HEIGHT);
  println(encodedPosBuffer.width, encodedPosBuffer.height);
}

void draw() {

  background(20);





  //Bind varibales & buffers to the particles system shader
  psh.set("posBuffer", encodedPosBuffer);

  shader(psh);
  shape(particles);  
  resetShader(POINTS);

  //debug display
  cam.beginHUD();
  float s = 0.15;
  float h = 60;
  fill(20);
  noStroke();
  rect(0, 0, width, h);
  image(encodedPosBuffer, 0, h, encodedPosBuffer.width * s, encodedPosBuffer.height * s);

  showFPS();
  //noLoop();
  cam.endHUD();
}

void init(int w, int h) {
  WIDTH = w;
  HEIGHT = h;
  nbElement = (w * h);
  originalData = getPosData(w, h);
  /* originalData = new float[nbElement * VERT_CMP_COUNT];
   
   for (int i=0; i<nbElement; i++) {
   float x = i % 1728;
   float y = (i - x) / 1728;
   float z = 0.0;
   
   originalData[i + nbElement * 0] = x / (float)1728;
   originalData[i + nbElement * 1] = y / ((float)1600 / 3.0);
   originalData[i + nbElement * 2] = 0.0;
   }*/

  encodedPosBuffer = fp.encodeARGB32Float(originalData);
  posBuffer = new PingPongBuffer(this, encodedPosBuffer.width, encodedPosBuffer.height, P2D);
  posBuffer.setFiltering(2);
  posBuffer.enableTextureMipmaps(false);
  drawTextureIntoPingPongBuffer(posBuffer, encodedPosBuffer);

  //debug
  decodedData = fp.decodeARGB32Float(encodedPosBuffer);

  //create shape
  particles = createShape();
  particles.beginShape(POINTS);
  particles.strokeWeight(1);
  for (int i=0; i<nbElement; i++) {
    float x = i % encodedPosBuffer.width;
    float y = (i - x) / encodedPosBuffer.width;
    float z = 0.0;

    float r = decodedData[i] * 255;
    float g = decodedData[i + nbElement] * 255;
    float b = decodedData[i + nbElement * 2] * 255;


    particles.stroke(r, g, b);
    particles.vertex(x, y, z);
  }
  particles.endShape();

  psh.set("gridResolution", (float) WIDTH, (float)HEIGHT);
  psh.set("bufferResolution", (float) encodedPosBuffer.width, (float)encodedPosBuffer.height);
  psh.set("worldResolution", 250.0, 250.0, 250.0);
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

    float cx = i % 1728;
    float cy = (i - cx) / 1728;
    float u = cx / (float) 1728;
    float v = cy / (float) (1600/3.0);

    float phi = u * PI;
    float theta = v * TWO_PI;

    float x = sin(phi) * cos(theta);
    float y = sin(phi) * sin(theta);
    float z = cos(phi);

    //we remap x,y,z from [-1, 1] to [0, 1] for encoding
    float ex = x * 0.5 + 0.5;
    float ey = y * 0.5 + 0.5;
    float ez = z * 0.5 + 0.5;
    
     posInterleavedPosData[i + nbParticles * 0] = u;
     posInterleavedPosData[i + nbParticles * 1] = v;
     posInterleavedPosData[i + nbParticles * 2] = 0.5;
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
