package gpuimage.core;

import processing.core.*;
import processing.opengl.*;


/**
 * Filter wich provide various postFX and filtering methods usefull for design or computer vision.
 * Each available shaders are define in the GPUImageInterface.
 * @see GPUImageInterface
 * 
 * @author bonjour
 */
public class Filter extends GPUImageBaseEffects{
	public Filter(PApplet papplet) {
		super.init(papplet);
	}
	
	public Filter(PApplet papplet, int width, int height) {
		super.init(papplet, width, height);
	}
	

	/* ...............................................
	 * 
	 * 
	 * 					FILTERING 
	 * 
	 * 
	 ...............................................*/
	
	
	/**Bilateral filtering
	 * @param src source layer
	 */
	public PGraphics getBilateralImage(PImage src) {
		super.setCurrentSH(BILATERAL);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**Simple denoiser based on average neighbors pixels
	 * @param src source layer
	 */
	public PGraphics getDenoiseImage(PImage src) {
		super.setCurrentSH(DENOISE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**Median filter based on the 3×3 neighbors
	 * @param src source layer
	 */
	public PGraphics getMedian3x3Image(PImage src) {
		super.setCurrentSH(MEDIAN3X3);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}

	/**Median filter based on the 5×5 neighbors
	 * @param src source layer
	 */
	public PGraphics getMedian5x5Image(PImage src) {
		super.setCurrentSH(MEDIAN5X5);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * High pass filter
	 * @param src source layer
	 * @param radius sharpening factor between 0 and X (default is 1.0)
	 * @return
	 */
	public PGraphics getHighPassImage(PImage src, float radius) {
		super.setCurrentSH(HIGHPASS);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("sharpFactor", radius);
		return super.filter(src);
	}
	
	/**
	 * Hue segmentation filter with a hue resolution at 1.0
	 * @param src source layer
	 * @return
	 */
	public PGraphics getHueSegmentationImage(PImage src) {
		super.setCurrentSH(HUESEGMENTATION);
		super.currentSH.set("hueStepper", 1.0f);
		return super.filter(src);
	}
	
	/**
	 * Hue segmentation filter
	 * @param src source layer
	 * @param huestep resolution per hue (by default the huer resolution is set at 1.0);
	 * @return
	 */
	public PGraphics getHueSegmentationImage(PImage src, float hueresolution) {
		super.setCurrentSH(HUESEGMENTATION);
		super.currentSH.set("hueStepper", hueresolution);
		return super.filter(src);
	}
	
	/**
	 * Sobel filter
	 * @param src source layer
	 * @param src
	 * @return
	 */
	public PGraphics getSobelImage(PImage src) {
		super.setCurrentSH(SOBEL);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("sobelxScale", 1.0f);
		super.currentSH.set("sobelyScale", 1.0f);
		return super.filter(src);
	}
	
	/**
	 * Sobel filter
	 * @param src source layer
	 * @param sobelXScale scale of the sobel on X between [0, X] (default is 1.0)
	 * @param sobelYScale scale of the sobel on Y between [0, X] (default is 1.0)
	 * @return
	 */
	public PGraphics getSobelImage(PImage src, float sobelXScale, float sobelYScale) {
		super.setCurrentSH(SOBEL);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("sobelxScale", sobelXScale);
		super.currentSH.set("sobelyScale", sobelYScale);
		return super.filter(src);
	}
	
	/**
	 * Sobel edge filter
	 * @param src source layer
	 * @param src
	 * @return
	 */
	public PGraphics getSobelEdgeImage(PImage src) {
		super.setCurrentSH(SOBELEDGE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("sobelxScale", 1.0f);
		super.currentSH.set("sobelyScale", 1.0f);
		return super.filter(src);
	}
	
	/**
	 * Sobel edge filter
	 * @param src source layer
	 * @param sobelXScale scale of the sobel on X between [0, X] (default is 1.0)
	 * @param sobelYScale scale of the sobel on Y between [0, X] (default is 1.0)
	 * @return
	 */
	public PGraphics getSobelEdgeImage(PImage src, float sobelXScale, float sobelYScale) {
		super.setCurrentSH(SOBELEDGE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("sobelxScale", sobelXScale);
		super.currentSH.set("sobelyScale", sobelYScale);
		return super.filter(src);
	}
	
	/**
	 * Canny edge filter using default sobel scale of 1.0 and default threshold of 0.5
	 * @param src source layer
	 * @param threshold threshold of the edge between [0, 1.0] where 0 = all detected edge and 1.0 = none
	 * @return
	 */
	public PGraphics getCannyEdgeImage(PImage src) {
		return getCannyEdgeImage(src, 1.0f, 1.0f, 0.5f);
	}
	
	/**
	 * Canny edge filter using default sobel scale of 1.0
	 * @param src source layer
	 * @param threshold threshold of the edge between [0, 1.0] where 0 = all detected edge and 1.0 = none
	 * @return
	 */
	public PGraphics getCannyEdgeImage(PImage src, float threshold) {
		return getCannyEdgeImage(src, 1.0f, 1.0f, threshold);
	}
	
	/**
	 * Canny edge filter
	 * @param src source layer
	 * @param sobelXScale scale of the sobel on X between [0, X] (default is 1.0)
	 * @param sobelYScale scale of the sobel on Y between [0, X] (default is 1.0)
	 * @param threshold threshold of the edge between [0, 1.0] where 0 = all detected edge and 1.0 = none
	 * @return
	 */
	public PGraphics getCannyEdgeImage(PImage src, float sobelXScale, float sobelYScale, float threshold) {
		super.setCurrentSH(CANNYEDGE);
		//first sobel pass
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("sobelxScale", sobelXScale);
		super.currentSH.set("sobelyScale", sobelYScale);
		PGraphics tmp = super.filter(src);
		//Horizontal pass
		super.setCurrentSH("cannyedge2");
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("lowerThreshold", threshold);
		return super.filter(tmp);
	}
	
	/**
	 * Dilation filter on black/white image
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDilationImage(PImage src) {
		super.setCurrentSH(GPUImageInterface.DILATE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Dilation filter on rgb image
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDilationRGBImage(PImage src) {
		super.setCurrentSH(DILATERGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Erosion filter on rgb image
	 * @param src source layer
	 * @return
	 */
	public PGraphics getErosionImage(PImage src) {
		super.setCurrentSH(GPUImageInterface.ERODE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Erosion filter on rgb image
	 * @param src source layer
	 * @return
	 */
	public PGraphics getErosionRGBImage(PImage src) {
		super.setCurrentSH(ERODERGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a signed distance filmed from a 1 channel image (black and white)
	 * @param src source layer
	 * @return
	 */
	public PGraphics getSignedDistanceFieldImage(PImage src) {
		return getSignedDistanceFieldImage(src, 5);
	}
	
	/**
	 * Get a signed distance filmed from a 1 channel image (black and white)
	 * @param src source layer
	 * @param searchDistance search distance in pixel
	 * @return
	 */
	public PGraphics getSignedDistanceFieldImage(PImage src, int searchDistance) {
		super.setCurrentSH(SIGNEDDISTANCEFIELD);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("searchDistance", searchDistance);
		return super.filter(src);
	}
	
	/* ...............................................
	 * 
	 * 
	 * 					  BLUR 
	 * 
	 * 
	 ...............................................*/
	
	/**
	 * Optimized gaussian blur (without using any forloop into the shader)
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param QUALITY define the number of neighbors pixels used
	 * LOW : 5×5
	 * MED : 9×9
	 * HIGH : 7×7
	 * HIGH2 : 13×13
	 */
	public PGraphics getOptimizedGaussianBlurImage(PImage src, float blurSize, String QUALITY) {
		switch(QUALITY) {
			case LOW :   return getGaussianBlurLowImage(src, blurSize);
			case MED :   return getGaussianBlurMediumImage(src, blurSize);
			case HIGH :  return getGaussianBlurHighImage(src, blurSize);
			case HIGH2 : return getGaussianBlurUltraHighImage(src, blurSize);
			default :    return getGaussianBlurLowImage(src, blurSize);
		}
	}
	
	/**
	 * Optimized low quality gaussian blur
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getGaussianBlurLowImage(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR5X5);
	}

	/**
	 * Optimized medium quality gaussian blur
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getGaussianBlurMediumImage(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR7X7);
	}

	
	/**
	 * Optimized high quality gaussian blur
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getGaussianBlurHighImage(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR9X9);
	}
	/**
	 * Optimized ultra high quality gaussian blur
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getGaussianBlurUltraHighImage(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR13X13);
	}
	
	/**
	 * Gaussian blur filter
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param radius define the number of for loopiteration (neighbors pixels used) 
	 */
	public PGraphics getGaussianBlurImage(PImage src, float blurSize, float radius) {
		super.setCurrentSH(GAUSSIANBLUR);
		//currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("radius", radius);
		super.currentSH.set("sigma", blurSize);
		//Vertical pass 
		super.currentSH.set("dir", 0.0f, 1.0f);
		super.currentSH.set("blurSize", 1.0f / (float)src.width);
		PGraphics tmp = super.filter(src);
		//Horizontal pass
		super.currentSH.set("dir", 1.0f, 0.0f);
		super.currentSH.set("blurSize", 1.0f / (float)src.height);
		return super.filter(tmp);
	}
	
	private PGraphics getFastGaussianBlur(PImage src, float blurSize, String NAME) {
		super.setCurrentSH(NAME);
		//currentSH.set("radius", radius);
		super.currentSH.set("sigma", blurSize);
		//Vertical pass 
		super.currentSH.set("dir", 0.0f, 1.0f);
		super.currentSH.set("blurSize", 1.0f / (float)src.width);
		PGraphics tmp = super.filter(src);
		//Horizontal pass
		super.currentSH.set("dir", 1.0f, 0.0f);
		super.currentSH.set("blurSize", 1.0f / (float)src.height);
		return super.filter(tmp);
	}
	
	/**
	 * Radial blur from the center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param QUALITY define the number iteration
	 * LOW : 4
	 * MED : 10
	 * HIGH : 20
	 * @return
	 */
	public PGraphics getOptimizedRadialBlurImage(PImage src, float blurSize, String QUALITY) {
		return getOptimizedRadialBlurImage(src, (float) src.width / 2.0f, (float) src.height / 2.0f, blurSize, QUALITY);
	}
	
	/**
	 * Radial blur
	 * @param src source layer
	 * @param originX origin x of the blur
	 * @param originY origin x of the blur
	 * @param blurSize size of the blur
	 * @param QUALITY define the number iteration
	 * LOW : 4
	 * MED : 10
	 * HIGH : 20
	 * @return
	 */
	public PGraphics getOptimizedRadialBlurImage(PImage src, float originX, float originY, float blurSize, String QUALITY) {
		switch(QUALITY) {
			case LOW : 	return getRadialBlurLowImage(src, originX, originY, blurSize);
			case MED : 	return getRadialBlurMediumImage(src, originX, originY, blurSize);
			case HIGH : return getRadialBlurHighImage(src, originX, originY, blurSize);
			default : 	return getRadialBlurLowImage(src, originX, originY, blurSize);
		}
	}
	
	/**
	 * Optimized low quality radial blur
	 * @param src source layer
	 * @param originX origin x of the blur
	 * @param originY origin y of the blur
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getRadialBlurLowImage(PImage src, float originX, float originY, float blurSize) {
		super.setCurrentSH(RADIALBLURLOW);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	/**
	 * Optimized low quality radial blur from the center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getCenteredRadialBlurLowImage(PImage src, float blurSize) {
		super.setCurrentSH(RADIALBLURLOW);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin",  (float) src.width / 2.0f, (float) src.height / 2.0f);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	/**
	 * Optimized medium quality radial blur
	 * @param src source layer
	 * @param originX origin x of the blur
	 * @param originY origin y of the blur
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getRadialBlurMediumImage(PImage src, float originX, float originY, float blurSize) {
		super.setCurrentSH(RADIALBLURMED);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	/**
	 * Optimized medium quality radial blur from the center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getCenteredRadialBlurMediumImage(PImage src, float blurSize) {
		super.setCurrentSH(RADIALBLURMED);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin",  (float) src.width / 2.0f, (float) src.height / 2.0f);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	/**
	 * Optimized high quality radial blur
	 * @param src source layer
	 * @param originX origin x of the blur
	 * @param originY origin y of the blur
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getRadialBlurHighImage(PImage src, float originX, float originY, float blurSize) {
		super.setCurrentSH(RADIALBLURLHIGH);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	/**
	 * Optimized high quality radial blur from the center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @return
	 */
	public PGraphics getCenteredRadialBlurHighImage(PImage src, float blurSize) {
		super.setCurrentSH(RADIALBLURLHIGH);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin",  (float) src.width / 2.0f, (float) src.height / 2.0f);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	/**
	 * Radial blur from the center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param step number of iteration
	 * @return
	 */
	public PGraphics getRadialBlurImage(PImage src, float blurSize, int step) {
		return getRadialBlurImage(src, (float)src.width/2, (float)src.height/2, blurSize, step);
	}
	
	/**
	 * Radial blur
	 * @param src source layer
	 * @param originX origin x of the blur
	 * @param originY origin x of the blur
	 * @param blurSize size of the blur
	 * @param step number of iteration
	 * @return
	 */
	public PGraphics getRadialBlurImage(PImage src, float originX, float originY, float blurSize, int step) {
		super.setCurrentSH(RADIALBLUR);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("octave", step);
		return super.filter(src);
	}

	/* ...............................................
	 * 
	 * 
	 * 					COLOR 
	 * 
	 * 
	 ...............................................*/
	
	/**Brighntess adjustment
	 * @param src source layer
	 * @param brightness is define as percent. A base brighntess is 100, a lowest will be 50 (50%) and highest could be 150 (150%)
	 */
	public PGraphics getBrightnessImage(PImage src, float brightness) {
		return getContrastSaturationBrightnessImage(src, 100.0f, 100.0f, brightness);
	}
	
	/**Contrast adjustment
	 * @param src source layer
	 * @param contrast is define as percent. A base contrast is 100, a lowest will be 50 (50%) and highest could be 150 (150%)
	 */
	public PGraphics getContrastImage(PImage src, float contrast) {
		return getContrastSaturationBrightnessImage(src, contrast, 100.0f, 100.0f);
	}

	/**Satruation adjustment
	 * @param src source layer
	 * @param saturation is define as percent. A base saturation is 100, a lowest will be 50 (50%) and highest could be 150 (150%)
	 */
	public PGraphics getSaturationImage(PImage src, float saturation) {
		return getContrastSaturationBrightnessImage(src, 100.0f, saturation, 100.0f);
	}
	
	/**Contrast Saturation Brightness adjustment.
	 * @param src source layer
	 * For others params see the related methods :
	 * @see #getContrastImage(PImage src, float contrast)
	 * @see #getSaturationImage(PImage src, float saturation)
	 * @see #getBrightnessImage(PImage src, float brightness)
	 */
	public PGraphics getContrastSaturationBrightnessImage(PImage src, float contrast, float saturation, float brightness) {
		super.setCurrentSH(CONTRASTSATBRIGHT);
		super.currentSH.set("brightness", brightness/100.0f);
		super.currentSH.set("contrast", contrast/100.0f);
		super.currentSH.set("saturation", saturation/100.0f);
		return super.filter(src);
	}
	
	/**
	 * RGB Level adjustement on output only. See level filter on Photoshop or After Effect for more informations.
	 * For params see related methods
	 * @see #getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB)
	 * @see #getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue)
	 * @param src source layer
	 * @param gammaRed
	 * @param gammaGreen
	 * @param gammaBlue
	 * @return
	 */
	public PGraphics getLevelGammaImage(PImage src, float gammaRed, float gammaGreen, float gammaBlue) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRed, gammaGreen, gammaBlue, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);

	}
	
	/**
	 * RGB Level adjustement on output only. See level filter on Photoshop or After Effect for more informations.
	 * For params see related methods
	 * @see #getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB)
	 * @see #getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue)
	 * @param src source layer
	 * @param gammaRGB
	 * @return
	 */
	public PGraphics getLevelGammaImage(PImage src, float gammaRGB) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	/**
	 * RGB Level adjustement on output only. See level filter on Photoshop or After Effect for more informations.
	 * For params see related methods
	 * @see #getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB)
	 * @see #getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue)
	 * @param src source layer
	 * @param minInputRed
	 * @param minInputGreen
	 * @param minInputBlue
	 * @param maxInputRed
	 * @param maxInputGreen
	 * @param maxInputBlue
	 * @return
	 */
	public PGraphics getLevelInputImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRed, minInputGreen, minInputBlue, maxInputRed, maxInputGreen, maxInputBlue, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	/**
	 * RGB Level adjustement on output only. See level filter on Photoshop or After Effect for more informations.
	 * For params see related methods
	 * @see #getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB)
	 * @see #getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue)
	 * @param src source layer
	 * @param minInputRGB
	 * @param maxInputRGB
	 * @return
	 */
	public PGraphics getLevelInputImage(PImage src, float minInputRGB, float maxInputRGB) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	/**
	 * RGB Level adjustement on output only. See level filter on Photoshop or After Effect for more informations.
	 * For params see related methods
	 * @see #getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB)
	 * @see #getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue)
	 * @param src source layer
	 * @param minOutputRed
	 * @param minOutputGreen
	 * @param minOutputBlue
	 * @param maxOutputRed
	 * @param maxOutputGreen
	 * @param maxOutputBlue
	 * @return
	 */
	public PGraphics getLevelOutputImage(PImage src, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue) {
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRed, minOutputGreen, minOutputBlue, maxOutputRed, maxOutputGreen, maxOutputBlue);
	}
	
	/**
	 * RGB Level adjustement on output only. See level filter on Photoshop or After Effect for more informations.
	 * For params see related methods
	 * @see #getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB)
	 * @see #getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue)
	 * @param src source layer
	 * @param minOutputRGB
	 * @param maxOutputRGB
	 * @return
	 */
	public PGraphics getLevelOutputImage(PImage src, float minOutputRGB, float maxOutputRGB) {
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	/**
	 * RGB Level adjustement. See level filter on Photoshop or After Effect for more informations
	 * @param src source layer
	 * @param minInputRGB minimum value of the RGB (gray) input between 0/255
	 * @param maxInputRGB maximum value of the RGB (gray) input between 0/255
	 * @param gammaRGB gamma value of the RGB (gray) input between 0/X (1 is the default value)
	 * @param minOutputRGB minimum value of the RGB (gray) output between 0/255
	 * @param maxOutputRGB maximum value of the RGB (gray) output between 0/255
	 * @return
	 */
	public PGraphics getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB) {
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	/**
	 * RGB Level adjustement. See level filter on Photoshop or After Effect for more informations
	 * @param src source layer
	 * @param minInputRed minimum value of the red input between 0/255
	 * @param minInputGreen minimum value of the green input between 0/255
	 * @param minInputBlue minimum value of the blue input between 0/255
	 * @param maxInputRed maximum value of the red input between 0/255
	 * @param maxInputGreen maximum value of the green input between 0/255
	 * @param maxInputBlue maximum value of the blue input between 0/255
	 * @param gammaRed gamma value of the red input between 0/X (1 is the default value)
	 * @param gammaGreen gamma value of the green input between 0/X (1 is the default value)
	 * @param gammaBlue gamma value of the blue input between 0/X (1 is the default value)
	 * @param minOutputRed minimum value of the red output between 0/255
	 * @param minOutputGreen minimum value of the green output between 0/255
	 * @param minOutputBlue minimum value of the blue output between 0/255
	 * @param maxOutputRed maximum value of the red output between 0/255
	 * @param maxOutputGreen maximum value of the green output between 0/255
	 * @param maxOutputBlue maximum value of the blue output between 0/255
	 * @return
	 */
	public PGraphics getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue) {
		super.setCurrentSH(LEVEL);
		super.currentSH.set("minInput", minInputRed/255.0f, minInputGreen/255.0f, minInputBlue/255.0f);
		super.currentSH.set("maxInput", maxInputRed/255.0f, maxInputGreen/255.0f, maxInputBlue/255.0f);
		super.currentSH.set("minOutput", minOutputRed/255.0f, minOutputGreen/255.0f, minOutputBlue/255.0f);
		super.currentSH.set("maxOutput", maxOutputRed/255.0f, maxOutputGreen/255.0f, maxOutputBlue/255.0f);
		super.currentSH.set("gamma", gammaRed, gammaGreen, gammaBlue);
		return super.filter(src);
	}
	
	/**
	 * Linear to Gamma correction (2.2)
	 * @param src source layer
	 * @return
	 */
	public PGraphics getGammaCorrectionImage(PImage src) {
		return getGammaCorrectionImage(src, 2.2f);
	}
	
	/**
	 * Linear to custom Gamma correction
	 * @param src source layer
	 * @param gamma value
	 * @return
	 */
	public PGraphics getGammaCorrectionImage(PImage src, float gamma) {
		super.setCurrentSH(GAMMA);
		super.currentSH.set("gamma", gamma);
		return super.filter(src);
	}
	
	/**
	 * Desaturate an image
	 * @param src source layer
	 * @param desaturation desaturation ratio between 0 and 100
	 * @return
	 */
	public PGraphics getDesaturateImage(PImage src, float desaturation) {
		super.setCurrentSH(GPUImageInterface.DESATURATE);
		super.currentSH.set("desaturation", desaturation/100.0f);
		return super.filter(src);
	}
	
	/**
	 * Threshold on each channel RGB
	 * @param src source layer
	 * @param levelRed threshold value on the red channel between 0/255
	 * @param levelGreen threshold value on the blue channel between 0/255
	 * @param levelBlue threshold value on the green channel between 0/255
	 * @return
	 */
	public PGraphics getColorThresholdImage(PImage src, float levelRed, float levelGreen, float levelBlue) {
		super.setCurrentSH(COLORTHRESHOLD);
		super.currentSH.set("levelRed", levelRed/255.0f);
		super.currentSH.set("levelGreen", levelGreen/255.0f);
		super.currentSH.set("levelBlue", levelBlue/255.0f);
		return super.filter(src);
	}
	
	/**
	 * Threshold image
	 * @param src source layer
	 * @param level threshold value between 0/255
	 * @return
	 */
	public PGraphics getThresholdImage(PImage src, float level) {
		super.setCurrentSH(GPUImageInterface.THRESHOLD);
		super.currentSH.set("level", level/255.0f);
		return super.filter(src);
	}
	
	/**
	 * Color grading using 1D Look Up Table (LUT)
	 * @see 
	 * @param src source layer
	 * @param lut look up table
	 * @return
	 */
	public PGraphics getLut1DImage(PImage src, PImage lut) {
		super.setCurrentSH(GPUImageInterface.LUT1D);
		super.currentSH.set("lut", lut);
		return super.filter(src);
	}
	
	/**
	 * Ramp the luma value of the image from a look up texture (ramp)
	 * @param src source layer
	 * @param ramp ramp texture
	 * @return
	 */
	public PGraphics getRamp1DImage(PImage src, PImage ramp) {
		super.setCurrentSH(RAMP1D);
		super.currentSH.set("ramp", ramp);
		return super.filter(src);
	}
	
	/**
	 * Get the inverted color image
	 * @param src source layer
	 * @return
	 */
	public PGraphics getInvertImage(PImage src) {
		super.setCurrentSH(GPUImageInterface.INVERT);
		return super.filter(src);
	}
	
	/* ...............................................
	 * 
	 * 
	 * 					POSTFX 
	 * 
	 * 
	 ...............................................*/
	/**
	 * RGB Chroma warping. Origin is set as center of the source layer.
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @param QUALITY define the number iteration
	 * LOW : 4
	 * MED : 10
	 * HIGH : 20
	 * @return
	 */
	public PGraphics getOptimizedChromaWarpImage(PImage src, float blurSize, float splitAngle, String QUALITY) {
		return getOptimizedChromaWarpImage(src, (float) src.width / 2.0f, (float) src.height / 2.0f, blurSize, splitAngle, QUALITY);
	}
	
	/**
	 * RGB Chroma warping
	 * @param src source layer
	 * @param originX origin x of the chroma warp
	 * @param originY origin x of the chroma warp
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @param QUALITY define the number iteration
	 * LOW : 4
	 * MED : 10
	 * HIGH : 20
	 * @return
	 */
	public PGraphics getOptimizedChromaWarpImage(PImage src, float originX, float originY, float blurSize, float splitAngle, String QUALITY) {
		switch(QUALITY) {
			case LOW : 	return getChromaWarpLowImage(src, originX, originY, blurSize, splitAngle);
			case MED : 	return getChromaWarpMediumImage(src, originX, originY, blurSize, splitAngle);
			case HIGH : return getChromaWarpHighImage(src, originX, originY, blurSize, splitAngle);
			default : 	return getChromaWarpLowImage(src, originX, originY, blurSize, splitAngle);
		}
	}
	
	/**
	 * Optimized low quality chroma warpping
	 * @param src source layer
	 * @param originX origin x of the chroma warp
	 * @param originY origin x of the chroma warp
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpLowImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPLOW);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * Optimized low quality chroma warpping from center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpLowImage(PImage src, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPLOW);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", (float)src.width / 2.0f, (float)src.height / 2.0f);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * Optimized medium quality chroma warpping
	 * @param src source layer
	 * @param originX origin x of the chroma warp
	 * @param originY origin x of the chroma warp
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpMediumImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPMED);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * Optimized medium quality chroma warpping from center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpMediumImage(PImage src, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPMED);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin",(float)src.width / 2.0f, (float)src.height / 2.0f);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * Optimized high quality chroma warpping
	 * @param src source layer
	 * @param originX origin x of the chroma warp
	 * @param originY origin x of the chroma warp
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpHighImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPHIGH);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * Optimized high quality chroma warpping from center of the image
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpHighImage(PImage src, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPHIGH);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", (float)src.width / 2.0f, (float)src.height / 2.0f);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * RGB Chroma warping
	 * @param src source layer
	 * @param blurSize size of the blur
	 * @param step number of iteration
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpImage(PImage src, float blurSize, int step, float splitAngle) {
		return getChromaWarpImage(src, (float)src.width/2, (float)src.height/2, blurSize, step, splitAngle);
	}
	
	/**
	 * RGB Chroma warping
	 * @param src source layer
	 * @param originX origin x of the chroma warp
	 * @param originY origin x of the chroma warp
	 * @param blurSize size of the blur
	 * @param step number of iteration
	 * @param splitAngle angle offset of each channel
	 * @return
	 */
	public PGraphics getChromaWarpImage(PImage src, float originX, float originY, float blurSize, int step, float splitAngle) {
		super.setCurrentSH(CHROMAWARP);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("octave", step);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	/**
	 * Animated grain based on the millis() passed
	 * @param src source layer
	 * @param intensity between 0/1
	 * @return
	 */
	public PGraphics getAnimatedGrainImage(PImage src, float intensity) {
		return getGrainImage(src, intensity, 1.0f + ((float)this.papplet.millis() / 1000.0f));
	}
	
	/**
	 * Grain
	 * @param src source layer
	 * @param intensity between 0/1
	 * @return
	 */
	public PGraphics getGrainImage(PImage src, float intensity) {
		return getGrainImage(src, intensity, 1.0f);
	}

	/**
	 * Animated grain
	 * @param src source layer
	 * @param intensity between 0/1
	 * @param time
	 * @return
	 */
	public PGraphics getGrainImage(PImage src, float intensity, float time) {
		super.setCurrentSH(GRAIN);
		super.currentSH.set("intensity", intensity);
		super.currentSH.set("time", time);
		return super.filter(src);
	}
	
	/**
	 * Animated rgb grain based on the millis() passed
	 * @param src source layer
	 * @param intensity between 0/1
	 * @return
	 */
	public PGraphics getAnimatedGrainRGBImage(PImage src, float intensity) {
		return getGrainRGBImage(src, intensity, 1.0f + ((float)this.papplet.millis() / 1000.0f));
	}
	
	/**
	 * RGB Grain
	 * @param src source layer
	 * @param intensity between 0/1
	 * @return
	 */
	public PGraphics getGrainRGBImage(PImage src, float intensity) {
		return getGrainRGBImage(src, intensity, 1.0f);
	}

	/**
	 * Animated rgb grain
	 * @param src source layer
	 * @param intensity between 0/1
	 * @param time
	 * @return
	 */
	public PGraphics getGrainRGBImage(PImage src, float intensity, float time) {
		super.setCurrentSH(GRAINRGB);
		super.currentSH.set("intensity", intensity);
		super.currentSH.set("time", time);
		return super.filter(src);
	}
	
	/**
	 * Pixelate an image at 100 pixel per width
	 * @param src source layer
	 * @return
	 */
	public PGraphics getPixelateImage(PImage src) {
		super.setCurrentSH(PIXELATE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("pixelRes", 100.0f);
		return super.filter(src);
	}
	
	/**
	 * Pixelate an image
	 * @param src source layer
	 * @param pixelRes number of pixel per width
	 * @return
	 */
	public PGraphics getPixelateImage(PImage src, float pixelRes) {
		super.setCurrentSH(PIXELATE);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("pixelRes", pixelRes);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 2x2 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer2x2Image(PImage src) {
		super.setCurrentSH(DITHERBAYER2X2);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 2x2 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer2x2RGBImage(PImage src) {
		super.setCurrentSH(DITHERBAYER2X2RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 3x3 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer3x3Image(PImage src) {
		super.setCurrentSH(DITHERBAYER3X3);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 3x3 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer3x3RGBImage(PImage src) {
		super.setCurrentSH(DITHERBAYER3X3RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 4x4 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer4x4Image(PImage src) {
		super.setCurrentSH(DITHERBAYER4X4);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 4x4 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer4x4RGBImage(PImage src) {
		super.setCurrentSH(DITHERBAYER4X4RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 8x8 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer8x8Image(PImage src) {
		super.setCurrentSH(DITHERBAYER8X8);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 8x8 Bayer Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherBayer8x8RGBImage(PImage src) {
		super.setCurrentSH(DITHERBAYER8X8RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 4x4 Cluster Dot Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherClusterDot4x4Image(PImage src) {
		super.setCurrentSH(DITHERCLUSTERDOT4X4);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 4x4 Cluster Dot Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherClusterDot4x4RGBImage(PImage src) {
		super.setCurrentSH(DITHERCLUSTERDOT4X4RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 8x8 Cluster Dot Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherClusterDot8x8Image(PImage src) {
		super.setCurrentSH(DITHERCLUSTERDOT8X8);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 8x8 Cluster Dot Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherClusterDot8x8RGBImage(PImage src) {
		super.setCurrentSH(DITHERCLUSTERDOT8X8RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 5x3 Cluster Dot Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherClusterDot5x3Image(PImage src) {
		super.setCurrentSH(DITHERCLUSTERDOT5X3);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 5x3 Cluster Dot Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherClusterDot5x3RGBImage(PImage src) {
		super.setCurrentSH(DITHERCLUSTERDOT5X3RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a greyscale dithering image based on 3x3 Random Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherRandom3x3Image(PImage src) {
		super.setCurrentSH(DITHERRANDOM3X3);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a rgb dithering image based on 3x3 Random Matrix
	 * @param src source layer
	 * @return
	 */
	public PGraphics getDitherRandom3x3RGBImage(PImage src) {
		super.setCurrentSH(DITHERRANDOM3X3RGB);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/*
	 * This methods binds the global glitch variables to the glitch shaders
	 */
	private void setGlitchParam( float intensity, float time, float columns, float rows, float subdivision, float breaktime, float speedtime, float frequency, float amplitude) {
		super.currentSH.set("intensity", (float)intensity);
		super.currentSH.set("time", (float)time);
		super.currentSH.set("colsrows", (float)columns, (float)rows);
		super.currentSH.set("subdivision", (float)subdivision);
		super.currentSH.set("breakTime", (float)breaktime);
		super.currentSH.set("speedTime", (float)speedtime);
		super.currentSH.set("frequency", (float)frequency);
		super.currentSH.set("amplitude", (float)amplitude);
	}
	
	/**
	 * Get a displace luma glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param deviationX deviation on X between 0.0 and 1.0
	 * @param deviationY deviation on Y between 0.0 and 1.0
	 * @return
	 */
	public PGraphics getGlitchDisplaceLuma(PImage src, float intensity, float time, float deviationX, float deviationY) {
		return this.getGlitchDisplaceLuma(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f, deviationX, deviationY);
	}
	
	/**
	 * Get a displace luma glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @param deviationX deviation on X between 0.0 and 1.0
	 * @param deviationY deviation on Y between 0.0 and 1.0
	 * @return
	 */
	public PGraphics getGlitchDisplaceLuma(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude, float deviationX, float deviationY) {
		super.setCurrentSH(GLITCHDISPLACELUMA);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		super.currentSH.set("deviation", (float)deviationX, (float)deviationY);
		return super.filter(src);
	}
	
	/**
	 * Get a displace rgb glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param deviationX deviation on X between 0.0 and 1.0
	 * @param deviationY deviation on Y between 0.0 and 1.0
	 * @return
	 */
	public PGraphics getGlitchDisplaceRGB(PImage src, float intensity, float time, float deviationX, float deviationY) {
		return this.getGlitchDisplaceRGB(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f, deviationX, deviationY);
	}
	
	/**
	 * Get a displace rgb glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @param deviationX deviation on X between 0.0 and 1.0
	 * @param deviationY deviation on Y between 0.0 and 1.0
	 * @return
	 */
	public PGraphics getGlitchDisplaceRGB(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude, float deviationX, float deviationY) {
		super.setCurrentSH(GLITCHDISPLACERGB);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		super.currentSH.set("deviation", (float)deviationX, (float)deviationY);
		return super.filter(src);
	}
	
	/**
	 * Get a invert glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @return
	 */
	public PGraphics getGlitchInvert(PImage src, float intensity, float time) {
		return this.getGlitchInvert(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f);
	}
	
	/**
	 * Get a invert glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @return
	 */
	public PGraphics getGlitchInvert(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude) {
		super.setCurrentSH(GLITCHINVERT);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		return super.filter(src);
	}
	
	/**
	 * * Get a pixelated glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param pixelres resolution of the pixels
	 * @return
	 */
	public PGraphics getGlitchPixelated(PImage src, float intensity, float time, float pixelres) {
		return this.getGlitchPixelated(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f, pixelres);
	}
	
	/**
     * Get a pixelated glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @param pixelres resolution of the pixels
	 * @return
	 */
	public PGraphics getGlitchPixelated(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude, float pixelres) {
		super.setCurrentSH(GLITCHPIXELATE);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		super.currentSH.set("pixelres", (float)pixelres);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		return super.filter(src);
	}
	
	/**
	 * Get a shift RGB glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param deviationredX red deviation on x between 0.0 and 1.0
	 * @param deviationredY red deviation on y between 0.0 and 1.0
	 * @param deviationgreenX green deviation on x between 0.0 and 1.0
	 * @param deviationgreenY green deviation on y between 0.0 and 1.0
	 * @param deviationblueX blue deviation on x between 0.0 and 1.0
	 * @param deviationblueY blue deviation on y between 0.0 and 1.0
	 * @return
	 */
	public PGraphics getGlitchShiftRGB(PImage src, float intensity, float time, float deviationredX, float deviationredY, float deviationgreenX, float deviationgreenY, float deviationblueX, float deviationblueY) {
		return this.getGlitchShiftRGB(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f, deviationredX, deviationredY, deviationgreenX, deviationgreenY, deviationblueX, deviationblueY);
	}
	
	/**
	 * Get a shift RGB glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @param deviationredX red deviation on x between 0.0 and 1.0
	 * @param deviationredY red deviation on y between 0.0 and 1.0
	 * @param deviationgreenX green deviation on x between 0.0 and 1.0
	 * @param deviationgreenY green deviation on y between 0.0 and 1.0
	 * @param deviationblueX blue deviation on x between 0.0 and 1.0
	 * @param deviationblueY blue deviation on y between 0.0 and 1.0
	 * @return
	 */
	public PGraphics getGlitchShiftRGB(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude, float deviationredX, float deviationredY, float deviationgreenX, float deviationgreenY, float deviationblueX, float deviationblueY) {
		super.setCurrentSH(GLITCHSHIFTRGB);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		super.currentSH.set("deviationred", (float)deviationredX, (float)deviationredY);
		super.currentSH.set("deviationgreen", (float)deviationgreenX, (float)deviationgreenY);
		super.currentSH.set("deviationblue", (float)deviationblueX, (float)deviationblueY);
		return super.filter(src);
	}
	
	/**
	  * Get shuffle RGB glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param contrast contrast of the shuffle
	 * @return
	 */
	public PGraphics getGlitchShuffleRGB(PImage src, float intensity, float time, float contrast) {
		return this.getGlitchShuffleRGB(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f, contrast);
	}
	
	/**
	 * Get shuffle RGB glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @param contrast contrast of the shuffle
	 * @return
	 */
	public PGraphics getGlitchShuffleRGB(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude, float contrast) {
		super.setCurrentSH(GLITCHSHUFFLERGB);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		super.currentSH.set("contrast", (float)contrast);
		return super.filter(src);
	}
	
	/**
	 * Get Stitch pixel glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @return
	 */
	public PGraphics getGlitchStitch(PImage src, float intensity, float time) {
		return this.getGlitchStitch(src, intensity, time, 2.0f, 8.0f, 0.5f, 1.0f, 0.25f, 0.037f, 0.01f);
	}
	
	/**
	 * Get Stitch pixel glitch
	 * @param src source layer
	 * @param intensity intensity of the glitch (0.0 = no glicth, 1, full glitch)
	 * @param time animation time
	 * @param columns number of columns for grid division
	 * @param rows number of rows for grid division
	 * @param subdivision ratio of subdivision per cells
	 * @param breaktime break point time for animation (between 0.0 and 1.0) 
	 * @param speedtime speed time scale
	 * @param frequency frequency of sin wave displacement on x
	 * @param amplitude amplitude of sin wave displacement on y
	 * @return
	 */
	public PGraphics getGlitchStitch(PImage src, float intensity, float time, float columns, float rows, float subdivision, float breaktime,  float speedtime, float frequency, float amplitude) {
		super.setCurrentSH(GLITCHSTITCH);
		this.setGlitchParam(intensity, time, columns, rows, subdivision, breaktime, speedtime, frequency, amplitude);
		return super.filter(src);
	}
	
	/**
	 * Bind the params of the optical flow to the datamoshing shader
	 * @param minVel
	 * @param maxVel
	 * @param offsetInc
	 * @param lambda
	 */
	private void setDatamoshingFlowParam(float minVel, float maxVel, float offsetInc, float lambda) {
		this.currentSH.set("minVel", minVel);
		this.currentSH.set("maxVel", maxVel);
		this.currentSH.set("offsetInc", offsetInc);
		this.currentSH.set("lambda", lambda);
	}
	
	/**
	 * Bind the params of the datamoshing shader
	 * @param threshold
	 * @param intensity
	 * @param offsetRGB
	 */
	private void setDatamoshingParam(float threshold, float intensity, float offsetRGB) {
		this.currentSH.set("threshold", threshold);
		this.currentSH.set("intensity", intensity);
		this.currentSH.set("offsetRGB", offsetRGB);
	}
	
	/**
	 * Get a datamoshing shader
	 * @param src source layer
	 * @param threshold minimum velocity to glitch
	 * @param intensity size of the glitch
	 * @param offsetRGB RGB offset
	 * @return
	 */
	public PGraphics getDatamoshing(PImage src, float threshold, float intensity, float offsetRGB) {
		super.setCurrentSH(DATAMOSHING);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		this.currentSH.set("previous", this.ppb.getSrcBuffer());
		this.setDatamoshingParam(threshold, intensity, offsetRGB);
		return super.filter(src);
	}
	
	/**
	 * Get a datamoshing shader
	 * @param src source layer
	 * @param minVel minimum velocity for optical flow (default is 0.01)
	 * @param maxVel maximum velocity for optical flow (default is 0.5)
	 * @param offsetInc offset increment for the sobel operator
	 * @param lambda lambda value of the gradient for optical flow
	 * @param threshold minimum velocity to glitch
	 * @param intensity size of the glitch
	 * @param offsetRGB RGB offset
	 * @return
	 */
	public PGraphics getDatamoshing(PImage src, float minVel, float maxVel, float offsetInc, float lambda, float threshold, float intensity, float offsetRGB) {
		super.setCurrentSH(DATAMOSHING);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		this.currentSH.set("previous", this.ppb.getSrcBuffer());
		this.setDatamoshingFlowParam(minVel, maxVel, offsetInc, lambda);
		this.setDatamoshingParam(threshold, intensity, offsetRGB);
		return super.filter(src);
	}

	/**
	 * Get a datamoshing shader
	 * @param src source layer
	 * @param threshold minimum velocity to glitch
	 * @param intensity size of the glitch
	 * @param offsetRGB RGB offset
	 * @return
	 */
	public PGraphics getDatamoshing3x3(PImage src, float threshold, float intensity, float offsetRGB) {
		super.setCurrentSH(DATAMOSHING3X3);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		this.currentSH.set("previous", this.ppb.getSrcBuffer());
		this.setDatamoshingParam(threshold, intensity, offsetRGB);
		return super.filter(src);
	}
	
	/**
	 * Get a datamoshing shader
	 * @param src source layer
	 * @param minVel minimum velocity for optical flow (default is 0.01)
	 * @param maxVel maximum velocity for optical flow (default is 0.5)
	 * @param offsetInc offset increment for the sobel operator
	 * @param lambda lambda value of the gradient for optical flow
	 * @param threshold minimum velocity to glitch
	 * @param intensity size of the glitch
	 * @param offsetRGB RGB offset
	 * @return
	 */
	public PGraphics getDatamoshing3x3(PImage src, float minVel, float maxVel, float offsetInc, float lambda, float threshold, float intensity, float offsetRGB) {
		super.setCurrentSH(DATAMOSHING3X3);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		this.currentSH.set("previous", this.ppb.getSrcBuffer());
		this.setDatamoshingFlowParam(minVel, maxVel, offsetInc, lambda);
		this.setDatamoshingParam(threshold, intensity, offsetRGB);
		return super.filter(src);
	}


	/**
	 * Get a datamoshing shader
	 * @param src source layer
	 * @param threshold minimum velocity to glitch
	 * @param intensity size of the glitch
	 * @param offsetRGB RGB offset
	 * @return
	 */
	public PGraphics getDatamoshing5x5(PImage src, float threshold, float intensity, float offsetRGB) {
		super.setCurrentSH(DATAMOSHING5X5);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		this.currentSH.set("previous", this.ppb.getSrcBuffer());
		this.setDatamoshingParam(threshold, intensity, offsetRGB);
		return super.filter(src);
	}
	
	/**
	 * Get a datamoshing shader
	 * @param src source layer
	 * @param minVel minimum velocity for optical flow (default is 0.01)
	 * @param maxVel maximum velocity for optical flow (default is 0.5)
	 * @param offsetInc offset increment for the sobel operator
	 * @param lambda lambda value of the gradient for optical flow
	 * @param threshold minimum velocity to glitch
	 * @param intensity size of the glitch
	 * @param offsetRGB RGB offset
	 * @return
	 */
	public PGraphics getDatamoshing5x5(PImage src, float minVel, float maxVel, float offsetInc, float lambda, float threshold, float intensity, float offsetRGB) {
		super.setCurrentSH(DATAMOSHING5X5);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		this.currentSH.set("previous", this.ppb.getSrcBuffer());
		this.setDatamoshingFlowParam(minVel, maxVel, offsetInc, lambda);
		this.setDatamoshingParam(threshold, intensity, offsetRGB);
		return super.filter(src);
	}
}