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
- [x] Processing ping pong buffer using PGraphics biding
PingPong buffer is an utils class allowing you to create a ping pong buffer in order to make read-write texture pipeline by creating 2 buffers
Each buffer can be swapped so the second is always a previous version of the first one. The main idea of this class is to keep the paradigm of an offscreen buffer made in processing using PGraphics and bind this buffer to the PinPongBuffer object. 
So user does not have to learn an new offscreen drawing implementation with various context and drawing methods.

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