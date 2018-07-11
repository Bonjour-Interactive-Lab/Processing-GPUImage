# GPUImage
Processing library for high-performance image computing and GPGPU computing (GLSL).

## Features

## To do
### Global
- [ ] Add try catch and handle errors
- [ ] Add custom throw error (view adidas source)

### Core 
- [x] Library info
- [x] simple GPU info
- [ ] custom GPU info (memory size...)

### Ping Pong Buffer
PingPong buffer is an utils class allowing you to create a ping pong buffer in order to make read-write texture pipeline by creating 2 buffers

- [x] Processing ping pong buffer using PGraphics
Each buffer can be swapped so the second is always a previous version of the first one. 
The main idea of this class is to keep the paradigm of an offscreen buffer made in processing using PGraphics through the PinPongBuffer object. User does not have to learn an new offscreen drawing implementation with various context and drawing methods. Drawing can be handle using
```
object.dst.beginDraw();
object.dst.endDraw();
```

- [x] Trying extend PGraphics in order to create a simple PingPongBuffer → ref :
* [Extending PGraphics (p5 forum)](https://forum.processing.org/two/discussion/5238/creating-a-layer-class-that-extends-pgraphics)
* [Extending Pgraphics (2) (p5 forum)](https://forum.processing.org/two/discussion/6884/question-about-pgraphics#Item_3)
* [Praxis implementation](https://github.com/praxis-live/praxis/blob/master/praxis.video.pgl/src/org/praxislive/video/pgl/PGLGraphics.java)
**WIP**
Processing ping pong buffer extending PGraphicsOpenGLClass
The class extends the PGraphicsOpenGL class in order to have the same drawing methods. At each swap the main buffer is copied into the prebious buffer using arrayCopy. User can draw into the PingPongGraphics using all the PGraphics methods
```
object.beginDraw();
object.endDraw();
```
This methods is a test méthods only. We need to make a benchmark in order to define the best solution.

- [ ] independant ping pong buffer (custom JOGL implementation) for Floating Point Texture

### Filtering
Filter list :

Denoiser/Blur/Filtering
- [ ] Bilateral
- [ ] Bicubic
- [ ] Simple Denoise
- [ ] Median 3×3 (TBD : iteration avec PingPong Buffer)
- [ ] Median 5×5 (TBD : iteration avec PingPong Buffer)
- [ ] Edge detection + Sobel + Canny

Blur
- [ ] BlurHV
- [ ] Gaussian
- [ ] Radial blur

Color :
- [ ] Brightness
- [ ] Contrast/Sat/Bright
- [ ] Desaturate
- [ ] Level
- [ ] Gamma
- [ ] LUT
- [ ] Photoshop fusion mode (multiply, add...)
- [ ] High-Passing
- [ ] Threshold

Effect/VFX :
- [ ] ChromaWarp
- [ ] Grain
- [ ] Dithering (TBD)
- [ ] Pixelate
- [ ] ASCII
- [ ] Bloom
- [ ] Double exposure

Other : 
- [ ] Mask
- [ ] Dilatation (TBD : iteration avec PingPong Buffer)
- [ ] Erosion (TBD : iteration avec PingPong Buffer)
- [ ] Optical Flow
- [ ] FrameDifferencing
- [ ] Pixel sorting
- [ ] DoF from Depth (TBD)
- [ ] Alpha Matte (sprite mode)

### RGBA packing
- [ ] ... (TBD)

### VBO (TBD)
### Procedural Texture (TBD)
### Wiki (TBD)