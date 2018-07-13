package gpuimage.core;

import processing.core.*;
import processing.opengl.*;

public class Compositor extends GPUImageBaseEffects{
	public Compositor(PApplet papplet) {
		super.init(papplet);
	}
	
	public Compositor(PApplet papplet, int width, int height) {
		super.init(papplet, width, height);
	}
	
	/** Draw the PPB with filter*/
	@Override protected void ppbFilter(PImage src, PShader filtersrc) {
		this.ppb.dst.beginDraw();
		//this.ppb.dst.clear();
		this.ppb.dst.background(127, 1);
		this.ppb.dst.shader(filtersrc);
		this.ppb.dst.image(src, 0, 0);
		this.ppb.dst.endDraw();
	}
	
	/* ...............................................
	 * 
	 * 
	 * 					MASK 
	 * 
	 * 
	 ...............................................*/
	
	/**
	 * Mask and image with a mask layer and return a alpha 0 PGraphics
	 * @param src source layer
	 * @param mask mask layer
	 * @return
	 */
	public PGraphics getMaskImage(PImage src, PImage mask) {
		super.setCurrentSH(MASK);
		super.currentSH.set("mask", mask);
		return super.filter(src);
	}
	
	/**
	 * Mask an image with a mask layer on the top of a base layer 
	 * @param src source layer
	 * @param base base layer
	 * @param mask mask layer
	 * @return
	 */
	public PGraphics getMaskImage(PImage src, PImage base, PImage mask) {
		super.setCurrentSH(MASK2);
		super.currentSH.set("mask", mask);
		super.currentSH.set("base", base);
		return super.filter(src);
	}
	
	/* ...............................................
	 * 
	 * 
	 * 					BLENDING 
	 * 
	 * 
	 ...............................................*/
	public PGraphics getBlendAddImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.ADD);
	}
	
	public PGraphics getBlendAverageImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.AVERAGE);
	}

	public PGraphics getBlendColorImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.COLOR);
	}

	public PGraphics getBlendColorBurnImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.COLORBURN);
	}

	public PGraphics getBlendColorDodgeImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.COLORDODGE);
	}

	public PGraphics getBlendDarkenImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.DARKEN);
	}

	public PGraphics getBlendDifferenceImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.DIFFERENCE);
	}

	public PGraphics getBlendExclusionImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.EXCLUSION);
	}

	public PGraphics getBlendGlowImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.GLOW);
	}

	public PGraphics getBlendHardLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.HARDLIGHT);
	}

	public PGraphics getBlendHardMixImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.HARDMIX);
	}

	public PGraphics getBlendHueImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.HUE);
	}

	public PGraphics getBlendLightenImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LIGHTEN);
	}

	public PGraphics getBlendLinearBurnImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LINEARBURN);
	}

	public PGraphics getBlendLinearDodgeImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LINEARDODGE);
	}

	public PGraphics getBlendLinearLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LINEARLIGHT);
	}

	public PGraphics getBlendLuminosityImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LUMINOSITY);
	}

	public PGraphics getBlendMultiplyImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.MULTIPLY);
	}

	public PGraphics getBlendNegationImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.NEGATION);
	}

	public PGraphics getBlendPhoenixImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.PHOENIX);
	}

	public PGraphics getBlendPinLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.PINLIGHT);
	}

	public PGraphics getBlendReflectImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.REFLECT);
	}

	public PGraphics getBlendSaturationImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SATURATION);
	}

	public PGraphics getBlendScreenImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SCREEN);
	}

	public PGraphics getBlendSoftLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SOFTLIGHT);
	}

	public PGraphics getBlendSubstractImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SUBSTRACT);
	}

	public PGraphics getBlendVividLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.VIVIDLIGHT);
	}
	
	public PGraphics getBlendImage(PImage src, PImage base, float opacity, String NAME) {
		super.setCurrentSH(NAME);
		super.currentSH.set("base", base);
		super.currentSH.set("opacity", opacity/100.0f);
		return super.filter(src);
	}
}