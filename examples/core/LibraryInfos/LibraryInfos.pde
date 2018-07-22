/**
* This example shows how to retreive the informations from the library as string.
* You can get library informations and GPU informations (Vendor, OpenGL & GLSL versions)
* --
* Bonjour Lab.
* http://www.bonjour-lab.com
*/
import gpuimage.core.*;

void setup() {
  size(100,100, P2D);
  smooth();
  GPUImage.printInfos();
  GPUImage.printGLInfos();
}

void draw() {
}
