package gpuimage.core;

import processing.core.*;
import processing.opengl.*;

/**
 * Compositor provide various GPU based blending methods for compositing between two image.<br>
 * The class is based on the same paradigme as photoshop where we have a src image (top layer) which is blend with a base image (bottom layer)
 * Each available shaders are define in the GPUImageInterface.
 * 
 * @see GPUImageInterface
 * @author bonjour
 *
 */
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
	/**
	 * Additive blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendAddImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.ADD);
	}
	
	/**
	 * Average blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendAverageImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.AVERAGE);
	}
	
	/**
	 * Color blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendColorImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.COLOR);
	}
	
	/**
	 * Color burn blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendColorBurnImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.COLORBURN);
	}
	
	/**
	 * Color dodge blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendColorDodgeImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.COLORDODGE);
	}
	
	/**
	 * Darken blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendDarkenImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.DARKEN);
	}
	
	/**
	 * Diffrence blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendDifferenceImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.DIFFERENCE);
	}
	
	/**
	 * Exclusion blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendExclusionImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.EXCLUSION);
	}
	
	/**
	 * Glow blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendGlowImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.GLOW);
	}
	
	/**
	 * Hard light blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendHardLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.HARDLIGHT);
	}
	
	/**
	 * Hard mix blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendHardMixImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.HARDMIX);
	}
	
	/**
	 * Hue blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendHueImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.HUE);
	}
	
	/**
	 * Lighten blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendLightenImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LIGHTEN);
	}
	
	/**
	 * Color blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendLinearBurnImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LINEARBURN);
	}
	
	/**
	 * Linear dodge blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendLinearDodgeImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LINEARDODGE);
	}
	
	/**
	 * Linear light blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendLinearLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LINEARLIGHT);
	}
	
	/**
	 * Luminosity blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendLuminosityImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.LUMINOSITY);
	}
	
	/**
	 * Multiply blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendMultiplyImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.MULTIPLY);
	}
	
	/**
	 * Negation blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendNegationImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.NEGATION);
	}
	
	/**
	 * Phoenix blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendPhoenixImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.PHOENIX);
	}
	
	/**
	 * Pin light blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendPinLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.PINLIGHT);
	}
	
	/**
	 * Reflect blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendReflectImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.REFLECT);
	}
	
	/**
	 * Saturation blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendSaturationImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SATURATION);
	}
	
	/**
	 * Screen blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendScreenImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SCREEN);
	}
	
	/**
	 * Soft light blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendSoftLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SOFTLIGHT);
	}
	
	/**
	 * Substract blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendSubstractImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.SUBSTRACT);
	}
	
	/**
	 * Vividlight blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendVividLightImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.VIVIDLIGHT);
	}
	
	/**
	 * Blend image
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @param NAME Blending name
	 * @return
	 */
	public PGraphics getBlendImage(PImage src, PImage base, float opacity, String NAME) {
		super.setCurrentSH(NAME);
		super.currentSH.set("base", base);
		super.currentSH.set("opacity", opacity/100.0f);
		return super.filter(src);
	}
}