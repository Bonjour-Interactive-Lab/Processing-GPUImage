package gpuimage.core;

import java.nio.file.Paths;
import java.util.HashMap;
import gpuimage.utils.*;
import processing.core.*;
import processing.opengl.*;
import processing.opengl.PGraphicsOpenGL;

/**
 * 
 * @author bonjour
 *
 */
public class Filter implements GPUFiltersInterface, PConstants{
	public static final String SHADERPATH = "shaders/";
	
	private PApplet papplet;
	private PingPongBuffer ppb;
	private PShader currentSH = new PShader();
	private HashMap<String, PShader> shaderlist = new HashMap<String, PShader>();
	
	public Filter(PApplet papplet) {
		this.papplet = papplet;
		this.initPPB(this.papplet, this.papplet.width, this.papplet.height);
	}
	
	public Filter(PApplet papplet, int width, int height) {
		this.papplet = papplet;
		this.initPPB(this.papplet, width, height);
	}
	
	private void initPPB(PApplet papplet, int width, int height) {
		if(this.papplet == null) {
			this.papplet = papplet;
		}
		
		this.ppb = new PingPongBuffer(this.papplet, width, height);
	}
	
	private void loadShader(String src) {
		PShader sh = this.papplet.loadShader(SHADERPATH+src+".glsl");
		shaderlist.put(src, sh);
	}
	
	private void checkIfShaderExists(String name) {
		if(shaderlist.containsKey(name)) {
		}else {
			this.loadShader(name);
		}
	}
	
	private void ppbFilter(PApplet papplet, PImage src, PShader filtersrc) {
		this.ppb.dst.beginDraw();
		this.ppb.dst.background(0);
		this.ppb.dst.shader(filtersrc);
		this.ppb.dst.image(src, 0, 0);
		this.ppb.dst.endDraw();
	}
	
	public PGraphics filter(PApplet papplet, PImage src, PShader filtersrc) {
		//check if papplet exist
		if(this.ppb != null && this.ppb.dst.width == src.width && this.ppb.dst.height == src.height) {
		}else {
			//or init
			this.initPPB(papplet, src.width, src.height);
		}
		
		//apply filter
		this.ppbFilter(papplet, src, filtersrc);

		//swap buffer
		this.ppb.swap();

		//return a clone of the PGraphics
		PGraphics filtered = this.ppb.getSrcBuffer();
		try {
			return filtered;
		}catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	// ........................................................
	private void setCurrentSH(String NAME) {
		this.checkIfShaderExists(NAME);
		currentSH = shaderlist.get(NAME);
	}
	
	public PGraphics getCustomFilter(PImage src, PShader customFilter) {
		currentSH = customFilter;
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getUV(PImage src) {
		this.setCurrentSH(UV);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		return filter(this.papplet, src, currentSH);
	}
	
	// FILTERING ...............................................
	public PGraphics getBilateralImage(PImage src) {
		this.setCurrentSH(BILATERAL);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		return filter(this.papplet, src, currentSH);
	}

	public PGraphics getDenoiseImage(PImage src) {
		this.setCurrentSH(DENOISE);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		return filter(this.papplet, src, currentSH);
	}

	public PGraphics getMedian3x3Image(PImage src) {
		this.setCurrentSH(MEDIAN3X3);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		return filter(this.papplet, src, currentSH);
	}

	public PGraphics getMedian5x5Image(PImage src) {
		this.setCurrentSH(MEDIAN5X5);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		return filter(this.papplet, src, currentSH);
	}
	
	// BLUR ......................................................
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
	
	
	public PGraphics getGaussianBlurImage(PImage src, float blurSize, float radius) {
		this.setCurrentSH(GAUSSIANBLUR);
		//currentSH.set("resolution", (float)src.width, (float)src.height);
		currentSH.set("radius", radius);
		currentSH.set("sigma", blurSize);
		//Vertical pass 
		currentSH.set("dir", 0.0f, 1.0f);
		currentSH.set("blurSize", 1.0f / (float)src.width);
		PGraphics tmp = filter(this.papplet, src, currentSH);
		//Horizontal pass
		currentSH.set("dir", 1.0f, 0.0f);
		currentSH.set("blurSize", 1.0f / (float)src.height);
		return filter(this.papplet, tmp, currentSH);
	}
	
	private PGraphics getFastGaussianBlur(PImage src, float blurSize, String NAME) {
		this.setCurrentSH(NAME);
		//currentSH.set("radius", radius);
		currentSH.set("sigma", blurSize);
		//Vertical pass 
		currentSH.set("dir", 0.0f, 1.0f);
		currentSH.set("blurSize", 1.0f / (float)src.width);
		PGraphics tmp = filter(this.papplet, src, currentSH);
		//Horizontal pass
		currentSH.set("dir", 1.0f, 0.0f);
		currentSH.set("blurSize", 1.0f / (float)src.height);
		return filter(this.papplet, tmp, currentSH);
	}

	// COLOR .....................................................
	public PGraphics getBrightnessImage(PImage src, float brightness) {
		this.setCurrentSH(CONTRASTSATBRIGHT);
		currentSH.set("brightness", brightness/100.0f);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getContrastImage(PImage src, float contrast) {
		this.setCurrentSH(CONTRASTSATBRIGHT);
		currentSH.set("contrast", contrast/100.0f);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getSaturationImage(PImage src, float saturation) {
		this.setCurrentSH(CONTRASTSATBRIGHT);
		currentSH.set("saturation", saturation/100.0f);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getContrastSaturationBrightnessImage(PImage src, float contrast, float saturation, float brightness) {
		this.setCurrentSH(CONTRASTSATBRIGHT);
		currentSH.set("brightness", brightness/100.0f);
		currentSH.set("contrast", contrast/100.0f);
		currentSH.set("saturation", saturation/100.0f);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getLevelGammaImage(PImage src, float gammaRed, float gammaGreen, float gammaBlue) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRed, gammaGreen, gammaBlue, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);

	}
	
	public PGraphics getLevelGammaImage(PImage src, float gammaRGB) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	public PGraphics getLevelInputImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRed, minInputGreen, minInputBlue, maxInputRed, maxInputGreen, maxInputBlue, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	public PGraphics getLevelInputImage(PImage src, float minInputRGB, float maxInputRGB) {
		float minOutputRGB = 0.0f;
		float maxOutputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	public PGraphics getLevelOutputImage(PImage src, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue) {
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRed, minOutputGreen, minOutputBlue, maxOutputRed, maxOutputGreen, maxOutputBlue);
	}
	
	public PGraphics getLevelOutputImage(PImage src, float minOutputRGB, float maxOutputRGB) {
		float minInputRGB = 0.0f;
		float maxInputRGB = 255.0f;
		float gammaRGB = 1.0f;
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	public PGraphics getLevelImage(PImage src, float minInputRGB, float maxInputRGB, float gammaRGB, float minOutputRGB, float maxOutputRGB) {
		return getLevelImage(src, minInputRGB, minInputRGB, minInputRGB, maxInputRGB, maxInputRGB, maxInputRGB, gammaRGB, gammaRGB, gammaRGB, minOutputRGB, minOutputRGB, minOutputRGB, maxOutputRGB, maxOutputRGB, maxOutputRGB);
	}
	
	public PGraphics getLevelImage(PImage src, float minInputRed, float minInputGreen, float minInputBlue, float maxInputRed, float maxInputGreen, float maxInputBlue, float gammaRed, float gammaGreen, float gammaBlue, float minOutputRed, float minOutputGreen, float minOutputBlue, float maxOutputRed, float maxOutputGreen, float maxOutputBlue) {
		this.setCurrentSH(LEVEL);
		currentSH.set("minInput", minInputRed/255.0f, minInputGreen/255.0f, minInputBlue/255.0f);
		currentSH.set("maxInput", maxInputRed/255.0f, maxInputGreen/255.0f, maxInputBlue/255.0f);
		currentSH.set("minOutput", minOutputRed/255.0f, minOutputGreen/255.0f, minOutputBlue/255.0f);
		currentSH.set("maxOutput", maxOutputRed/255.0f, maxOutputGreen/255.0f, maxOutputBlue/255.0f);
		currentSH.set("gamma", gammaRed, gammaGreen, gammaBlue);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getGammaCorrectionImage(PImage src) {
		return getGammaCorrectionImage(src, 2.2f);
	}
	
	public PGraphics getGammaCorrectionImage(PImage src, float gamma) {
		this.setCurrentSH(GAMMA);
		currentSH.set("gamma", gamma);
		return filter(this.papplet, src, currentSH);
	}
	
	// POSTFX .....................................................
	public PGraphics getOptimizedChromaWarpImage(PImage src, float blurSize, float splitAngle, String QUALITY) {
		return getOptimizedChromaWarpImage(src, (float) src.width / 2.0f, (float) src.height / 2.0f, blurSize, splitAngle, QUALITY);
	}
	
	public PGraphics getOptimizedChromaWarpImage(PImage src, float originX, float originY, float blurSize, float splitAngle, String QUALITY) {
		switch(QUALITY) {
			case LOW : 	return getChromaWarpLowImage(src, originX, originY, blurSize, splitAngle);
			case MED : 	return getChromaWarpMediumImage(src, originX, originY, blurSize, splitAngle);
			case HIGH : return getChromaWarpHighImage(src, originX, originY, blurSize, splitAngle);
			default : 	return getChromaWarpLowImage(src, originX, originY, blurSize, splitAngle);
		}
	}
	
	private PGraphics getChromaWarpLowImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		this.setCurrentSH(CHROMAWARPLOW);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		currentSH.set("blurSize", blurSize);
		currentSH.set("angle", splitAngle);
		return filter(this.papplet, src, currentSH);
	}
	
	private PGraphics getChromaWarpMediumImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		this.setCurrentSH(CHROMAWARPMED);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		currentSH.set("blurSize", blurSize);
		currentSH.set("angle", splitAngle);
		return filter(this.papplet, src, currentSH);
	}
	
	private PGraphics getChromaWarpHighImage(PImage src, float originX, float originY, float blurSize, float splitAngle) {
		this.setCurrentSH(CHROMAWARPHIGH);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		currentSH.set("blurSize", blurSize);
		currentSH.set("angle", splitAngle);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getChromaWarpImage(PImage src, float blurSize, int step, float splitAngle) {
		return getChromaWarpImage(src, (float)src.width/2, (float)src.height/2, blurSize, step, splitAngle);
	}
	
	public PGraphics getChromaWarpImage(PImage src, float originX, float originY, float blurSize, int step, float splitAngle) {
		this.setCurrentSH(CHROMAWARP);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		currentSH.set("blurOrigin", originX / (float)src.width, originY / (float)src.height);
		currentSH.set("blurSize", blurSize);
		currentSH.set("octave", step);
		currentSH.set("angle", splitAngle);
		return filter(this.papplet, src, currentSH);
	}
	
	public PGraphics getAnimatedGrainImage(PImage src, float intensity) {
		return getGrainImage(src, intensity, 1.0f + ((float)this.papplet.millis() / 1000.0f));
	}
	
	public PGraphics getGrainImage(PImage src, float intensity) {
		return getGrainImage(src, intensity, 1.0f);
	}
	
	public PGraphics getGrainImage(PImage src, float intensity, float time) {
		this.setCurrentSH(GRAIN);
		currentSH.set("intensity", intensity);
		currentSH.set("time", time);
		return filter(this.papplet, src, currentSH);
	}
	
	// OTHER .......................................................
	public PGraphics getMaskImage(PImage src, PImage mask) {
		this.setCurrentSH(MASK);
		currentSH.set("mask", mask);
		return filter(this.papplet, src, currentSH);
	}
	
}