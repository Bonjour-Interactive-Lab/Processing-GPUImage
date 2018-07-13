package gpuimage.core;

import processing.core.*;
import processing.opengl.*;
/**
 * Filtering class wich provide various postFX and filtering methods usefull for design, compositing or computervision.
 * Each available shaders are define in the GPUImageInterface.
 * @see #GPUImageInterface
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
			case LOW :   return getGaussianBlur5x5Image(src, blurSize);
			case MED :   return getGaussianBlur9x9Image(src, blurSize);
			case HIGH :  return getGaussianBlur7x7Image(src, blurSize);
			case HIGH2 : return getGaussianBlur13x13Image(src, blurSize);
			default :    return getGaussianBlur5x5Image(src, blurSize);
		}
	}
	
	private PGraphics getGaussianBlur5x5Image(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR5X5);
	}
	
	private PGraphics getGaussianBlur9x9Image(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR9X9);
	}
	
	private PGraphics getGaussianBlur7x7Image(PImage src, float blurSize) {
		return getFastGaussianBlur(src, blurSize, GAUSSIANBLUR7X7);
	}
	
	private PGraphics getGaussianBlur13x13Image(PImage src, float blurSize) {
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
	
	private PGraphics getRadialBlurLowImage(PImage src, float originX, float originY, float blurSize) {
		super.setCurrentSH(RADIALBLURLOW);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	private PGraphics getRadialBlurMediumImage(PImage src, float originX, float originY, float blurSize) {
		super.setCurrentSH(RADIALBLURMED);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		return super.filter(src);
	}
	
	private PGraphics getRadialBlurHighImage(PImage src, float originX, float originY, float blurSize) {
		super.setCurrentSH(RADIALBLURLHIGH);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
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
		super.setCurrentSH(CONTRASTSATBRIGHT);
		super.currentSH.set("brightness", brightness/100.0f);
		return super.filter(src);
	}
	
	/**Contrast adjustment
	 * @param src source layer
	 * @param contrast is define as percent. A base contrast is 100, a lowest will be 50 (50%) and highest could be 150 (150%)
	 */
	public PGraphics getContrastImage(PImage src, float contrast) {
		super.setCurrentSH(CONTRASTSATBRIGHT);
		super.currentSH.set("contrast", contrast/100.0f);
		return super.filter(src);
	}

	/**Satruation adjustment
	 * @param src source layer
	 * @param saturation is define as percent. A base saturation is 100, a lowest will be 50 (50%) and highest could be 150 (150%)
	 */
	public PGraphics getSaturationImage(PImage src, float saturation) {
		super.setCurrentSH(CONTRASTSATBRIGHT);
		super.currentSH.set("saturation", saturation/100.0f);
		return super.filter(src);
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
	
	private PGraphics getChromaWarpLowImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPLOW);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	private PGraphics getChromaWarpMediumImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPMED);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		super.currentSH.set("blurSize", blurSize);
		super.currentSH.set("angle", splitAngle);
		return super.filter(src);
	}
	
	private PGraphics getChromaWarpHighImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		super.setCurrentSH(CHROMAWARPHIGH);
		super.currentSH.set("resolution", (float)src.width, (float)src.height);
		super.currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
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
}