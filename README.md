# GPUImage
Processing library for high-performance image computing and GPGPU computing (GLSL).

## Features

## To do
### Global
[] Add try ctach and handle errors

### Core 
[x] Library info
[x] (simple) GPU info
[]  (custom) GPU info (memory size...)

### Ping Pong Buffer
[x] Processing ping pong buffer using PGraphics biding
PingPong buffer is an utils class allowing you to create a ping pong buffer in order to make read-write texture pipeline by creating 2 buffers
Each buffer can be swapped so the second is always a previous version of the first one.
  
The main idea of this class is to keep the paradigm of an offscreen buffer made in processing using PGraphics and bind this buffer to the PinPongBuffer object. 
So user does not have to learn an new offscreen drawing implementation with various context and drawing methods.

[] independant ping pong buffer (custom JOGL implementation) for Floating Point Texture

### Filtering
[] ... (TBD)

### RGBA packing
[] ... (TBD)

### VBO (TBD)
### Procedural Texture (TBD)
### Wiki (TBD)