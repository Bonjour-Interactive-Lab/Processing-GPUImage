/**
* This example shows how to use create and use ping pong buffer (or double buffering).
*
* Definition from GPGPU.org : http://gpgpu.org/developer/legacy-gpgpu-graphics-apis/glossary#RTT
* Ping-ponging is a technique used with RTT to avoid reading and writing the same buffer simultaneously, instead bouncing back and forth between a pair of buffers. 
* In iterative algorithms that write data in one pass and then read back that data to generate the results of the next pass, such a technique is often required. 
* In pass 1, data is written into buffer A, and then in pass 2, buffer A is bound for reading and buffer B is written. 
* If a third pass is required, buffer B becomes the source and buffer A becomes the destination.
*
* This technic is used when you need to use texture for GPGPU operation or in order to apply sequential filters.
* --
* Bonjour Lab.
* http://www.bonjour-lab.com
*/


import gpuimage.utils.*;

PingPongBuffer ppb;

void setup() {
  size(1200, 400, P2D);
  smooth();
  
  ppb = new PingPongBuffer(this, width/2, height); //define the width and height of the PPB
  //ppb.smooth(8);
  ppb.dst.smooth(8);
  
  frameRate(1);
}

void draw() {
  /**
  * The Ping Pong buffer handle a swap between two PGraphics buffers. You can draw on destination buffer using ppb.dst.beginDraw() as a simple PGraphics
  */
  ppb.dst.beginDraw();  
  ppb.dst.background(random(255), random(255), random(255));
  ppb.dst.ellipse(ppb.dst.width/2, ppb.dst.height/2, ppb.dst.height/2, ppb.dst.height/2);
  ppb.dst.endDraw();
  
  //get the PGraphics (destination and source buffers);
  image(ppb.getDstBuffer(), 0, 0);
  image(ppb.getSrcBuffer(), width/2, 0);

  noStroke();
  fill(0);
  rect(0, 0, width, 40);
  fill(255, 255, 255);
  text("ppb dst", 20 + 0, 20);
  text("ppb src", 20 + width/2, 20);
  
  ppb.swap();//Swap the buffer for the next loop
}
