# GPUImage
Processing library for high-performance image computing and GPGPU computing (GLSL).

| Plateforme : 	| Status:		|
|---------------|---------------|
| **`Windows`** | ![status](https://img.shields.io/badge/build-prerelease-green.svg?longCache=true&style=flat&colorA=grey&colorB=f48c42) |
| **`OSX`** 	| ![status](https://img.shields.io/badge/build-prerelease-green.svg?longCache=true&style=flat&colorA=grey&colorB=f48c42) |
| **`Linux`** 	| ![status](https://img.shields.io/badge/build-prerelease-green.svg?longCache=true&style=flat&colorA=grey&colorB=f48c42) |

## Features

* Image filtering (color, blur, effects, filtering...)
* Image compositing (fusion mode, mask, chroma key...)
* Ping Pong buffering
* Data packing into RGBA texture

## Tested platforms

* Windows :
  * Windows 10 x64, 16GO, intel i7 3.6Ghz, GPU NVidia GTX 970
  * Windows 10 x64, 16GO, intel i5 3.4Ghz, GPU NVidia GTX 660 #31
* Linux 16.04, 16GO, intel i7 3.60Ghz, GPU NVidia GTX 1080 #32
* OSX 10.13.5, 16GO, intel i7 2.5Ghz, GPU AMD Radeon R9 M370X #33   

## Informations and major updates
- The v.0.0.1 the library is build on the top of processing which means we are using processing class such as PGraphics, Pimage, PApplet...
- The v.1.0 is based on the processing PJOGL profile. There is no change in the GL context and it's still build on GL2ES2 (a version between GL2, GL3 and GLES2) [GL2ES2 JOGAMP](https://download.java.net/media/jogl/jogl-2.x-docs/javax/media/opengl/GL2ES2.html)
- **Because the library relies on the PJOGL profile (GL2ES2) all shaders are based on GLSL 1.50 (150) [GLSL versions table](https://www.opengl.org/discussion_boards/showthread.php/199965-picking-a-glsl-version)**. We don't set the version directive on the shader on order to keep compability with OSX plateform. See issue #29 for more informations
- #11 The effector system is design as a base component : **GPUImageBaseEffects** which is extends by 3 differents class : **Filter**, **Compositor** and **ProceduralTexture**. Each of them is based on the ping pong buffer system set in the **GPUImageBaseEffects**. Each of them can take cares of differents actions :
	- **Filter** : All filtering and VFX operations on a single image (chromawarp, blur, sobel...)
	- **Compositor** : Composition between two images (mask, blending...)
	- **ProceduralTexture** : Generation of procedural texture (noise, FBM, voronoi...)

## Architecture et Design Pattern
![Design Pattern](https://github.com/Bonjour-Interactive-Lab/Processing-GPUImage/blob/master/DesignPattern.png)

## To do
### Global/Recette
- [ ] Add try catch and handle errors
- [ ] Add custom throw error (view adidas source)
- [ ] Find good licenced image for library usage/example

### Core
- [x] Library info
- [x] simple GPU info
- [ ] custom GPU info (memory size...)

### PingPong Buffer
PingPong buffer is an utils class allowing you to create a ping pong buffer in order to make read-write texture pipeline by creating 2 buffers. For more information about the differents implementation test see issue #5

- [x] Processing ping pong buffer using PGraphics
Each buffer can be swapped so the second is always a previous version of the first one.
The main idea of this class is to keep the paradigm of an offscreen buffer made in processing using PGraphics through the PinPongBuffer object. User does not have to learn an new offscreen drawing implementation with various context and drawing methods. Drawing can be handle using
```java
object.dst.beginDraw();
object.dst.endDraw();
```

- [x] Trying extend PGraphics in order to create a simple PingPongBuffer ??? ref :
* [Extending PGraphics (p5 forum)](https://forum.processing.org/two/discussion/5238/creating-a-layer-class-that-extends-pgraphics)
* [Extending Pgraphics (2) (p5 forum)](https://forum.processing.org/two/discussion/6884/question-about-pgraphics#Item_3)
* [Praxis implementation](https://github.com/praxis-live/praxis/blob/master/praxis.video.pgl/src/org/praxislive/video/pgl/PGLGraphics.java)
**WIP**
Processing ping pong buffer extending PGraphicsOpenGLClass
The class extends the PGraphicsOpenGL class in order to have the same drawing methods. At each swap the main buffer is copied into the prebious buffer using arrayCopy. User can draw into the PingPongGraphics using all the PGraphics methods
```java
object.beginDraw();
object.endDraw();
```
This methods is a test methods only. We need to make a benchmark in order to define the best solution.
**NB : Tested on a filter methods inside a forloop, this method is too slow on the arrayCopy() (30 fps at 60 iterations) vs the previous one (60 fps at 60 iterations)**

- [ ] independant ping pong buffer (custom JOGL implementation) for Floating Point Texture

- [x] add smooth to PPB
- [ ] Add a custom PGraphicsOGL implementation using nearest filtering, warping... see issues #28 and #26

#### Others
- [x] add filtering capabilities :
```java
  buffer.hint(DISABLE_TEXTURE_MIPMAPS);
  ((PGraphicsOpenGL)buffer).textureSampling(3);
```

### Filtering/Compositor/Procedural Texture

#### GPUImageBaseEffects

#### Filter extends GPUImageBaseEffects

##### Filtering
- [x] Bilateral
* * [x] Debugger le filtre GLSL (Inversion d'UV)
- [x] Simple Denoise
* * [x] set custom param binding to shader
- [x] Median 3??3 (TBD : iteration avec PingPong Buffer)
- [x] Median 5??5 (TBD : iteration avec PingPong Buffer)
- [x] Edge detection + Sobel + Canny
- [x] High-Passing
- [x] Hue segmentation
- [x] Dilation
- [x] Erosion
- [ ] Signed Distance Field **To be corrected as true SDF**

##### Blur
- [x] Gaussian
* * [x] set custom param binding to shader
- [x] Fast Blur 5x5, 7x7, 9x9, 13x13
- [x] Radial blur + optimized low, medium, high

##### Color :
- [x] Contrast/Sat/Bright
- [x] Desaturate
- [x] Level
- [x] Gamma
* * [x] set custom param binding to shader
- [x] LUT (1D)
- [ ] LUT (2D)
- [x] Ramp (1D)
- [x] Color Threshold
- [x] Threshold
- [x] Invert image

##### Effect/VFX :
- [x] ChromaWarp + optimized low, medium, high
- [x] Fast ChromaWarp 4, 10, 20
- [x] Grain
- [x] Grain RGB
- [x] Dithering : Bayer (2x2, 3x3, 4x4, 8x8), Cluster Dot (4x4, 8x8, 5x3), Random (3x3)
- [x] Pixelate
- [ ] ASCII **Est-ce un filtre ou une composition ?** ??? http://paulbourke.net/dataformats/asciiart/ (class d??di??e)
- [ ] Bloom
- [ ] SlitScan effect
- [x] Glitches
- [x] Datamoshing

##### Other :
- [ ] Optical Flow
- [ ] FrameDifferencing
- [ ] Pixel sorting
- [ ] DoF from Depth (TBD)
- [ ] Normal Map converter

#### Compositor extends GPUImageBaseEffects
- [x] Photoshop fusion mode (multiply, add...)
  - [x] add
  - [x] average
  - [x] color
  - [x] colorburn
  - [x] colordodge
  - [x] darken
  - [x] difference
  - [x] exclusion
  - [x] glow
  - [x] hardlight
  - [x] hardmix
  - [x] hue
  - [x] lighten
  - [x] linearburn
  - [x] lineardodge
  - [x] linearlight
  - [x] luminosity
  - [x] multiply
  - [x] negation
  - [x] overlay
  - [x] phoenix
  - [x] pinlight
  - [x] reflect
  - [x] saturation
  - [x] screen
  - [x] softlight
  - [x] substract
  - [x] vividlight
- [x] Mask
* * [x] set custom param binding to shader
* * [x] clean shader
- [ ] Alpha Matte (sprite mode)
- [x] Chroma key

#### Procedural extends GPUImageBaseEffects
- [ ] Noise & Random
  - [ ] Noise
  - [ ] Random
  - [ ] Simplex
  - [ ] Gradient
  - [ ] Cellular
  - [ ] Fractal
  - [ ] Cellular
- [ ] Isosurface
- [ ] Reaction-Diffusion

### Packing RGBA
- [x] Float to RGBA algorithm [precision test](https://gitlab.bonjour-lab.com/alexr4/GPUImage/blob/master/floatToRGBAEncoding.md)
- [x] Abstract class with various encoding/decoding methods (RGBA16, 24, 32) from float and double
- [x] Main float packing class
- [x] RGBA1616 double packing ??? Allowing two data (1 per 2 channel 1616)
- [x] ModIntPacking allowing to pack int value into 8bits + 8bits index
- [ ] Bit shift packing to PImage (only usefull for CPU computation)
- [ ] Performances
  - [x] Quid to use generic type in order to simplify class writing ? (Not quite efficience for now)
  - [ ] Quid to thread encoding operation for performance ?
  - [x] Quid to bypass the PImage object in order to encode in a spediest way ?
    - Using BufferedImage seems to speed up the performance [Reference](http://www.java-gaming.org/index.php?topic=23013.0)
    - Using specific method without switch/case. The test was too low
  - [x] Find a way to create a rectangle from area only. [See sehrope implementation en stackoverflow](https://stackoverflow.com/questions/16266931/input-an-integer-find-the-two-closest-integers-which-when-multiplied-equal-th)
- [x] Pack/unpack RGBA (16/24/32) shader model
- [x] Pack/unpack RGBA1616 shader model
- [x] Pack/unpack RGBAMod shader model

### Geometric (VBO)
### Wiki (TBD)
### Exemples
- [ ] Composition
  - [x] Blending
  - [X] Mask
  - [ ] Alpha sprite
  - [x] Chromakey
- [x] Core
  - [x] Infos
- [x] Filters
  - [x] Sequential filtering
  - [x] Filtering
    - [x] Denoise (denoise, bilateral, median3x3, median5x5)
    - [x] Edge detection + Sobel + Canny
    - [x] High-Passing
    - [x] Hue segmentation
    - [x] Dilation/Erosion
  - [x] Blur
    - [x] Radial blur
    - [x] Gaussian blur
  - [x] Color grading
    - [x] Threshold (gray + color)
    - [x] LUT1D
    - [x] Ramp 1D
    - [x] Level
    - [x] Gamma correction
    - [x] Desaturation
    - [x] Contrast Saturation Brightness
    - [x] Invert
  - [x] Post fx
    - [x] White grain
    - [x] RGB grain
    - [x] Chroma warping
    - [x] Pixelate
    - [x] Ditherings
    - [x] Ditherings RGB
    - [x] Glitches
- [x] Other
  - [x] Accentuation
  - [x] ProcessHueSegmentation
  - [x] Kinect Depth IntToRGBA
  - [x] 2D GPU physics engine
  - [ ] 3D GPU physics engine (broken)
- [ ] Procedural
- [x] RGBA Encoding
- [x] Utils
  - [x] Generate 1D LUT
  - [X] Ping Pong Buffer
