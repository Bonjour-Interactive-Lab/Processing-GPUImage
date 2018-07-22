/**
* This example shows how to generate a 1D Look Up Table of color grading in your favorite image software then use it with the Filters class
* @see Filter class for more informations on how to use LUT
* --
* Bonjour Lab.
* http://www.bonjour-lab.com
*/
import gpuimage.core.*;

LUTGenerator lut;
PGraphics generatedLUT;

void setup() {
  size(256, 256, P2D);
  smooth();
  lut = new LUTGenerator(this);
  generatedLUT = lut.generateLUT1D();
  generatedLUT.save("lut1d.png");
}

void draw() {
  image(generatedLUT, 0, 0, width, height);
}
