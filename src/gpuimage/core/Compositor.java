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
	
	//check if any of the two types are differents (PImage/PGraphics) in order to change the UV
	private void checkUVSettings(PImage src, PImage base, String uniform) {
		boolean srcPImage = super.isPImage(src);
		boolean basePImage = super.isPImage(base);
		if(srcPImage != basePImage) {
			//the two buffers have differents type so some uv need to be inverted
			super.currentSH.set(uniform, 1);
			//super.currentSH.set(uniform, 0);
		}
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
		this.checkUVSettings(src,  mask, "srci");
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
		this.checkUVSettings(src,  mask, "srci");
		this.checkUVSettings(src,  base, "base2i");
		super.currentSH.set("mask", mask);
		super.currentSH.set("base", base);
		return super.filter(src);
	}
	
	/**
	 * Chroma key on image with a border threshold of 0.5f. Return keyed image on the top of the other
	 * @param src source layer
	 * @parma base base layer
	 * @param red red component of the key color between [0 - 255]
	 * @param green green component of the key color between [0 - 255]
	 * @param blue blue component of the key color between [0 - 255]
	 * @return
	 */
	public PGraphics getChromaKeyImage(PImage src, PImage base, float red, float green, float blue) {
		super.setCurrentSH(CHROMAKEY2);
		this.checkUVSettings(src, base, "srci");
		super.currentSH.set("keyColor", red/255.0f, green/255.0f, blue/255.0f);
		super.currentSH.set("threshold", 0.5f);
		super.currentSH.set("base", base);
		return super.filter(src);	
	}
	
	/**
	 * Chroma key on image. Return keyed image on the top of the other
	 * @param src source layer
	 * @parma base base layer
	 * @param red red component of the key color between [0 - 255]
	 * @param green green component of the key color between [0 - 255]
	 * @param blue blue component of the key color between [0 - 255]
	 * @param threshold border threshold between [0.0, 1.0]
	 * @return
	 */
	public PGraphics getChromaKeyImage(PImage src, PImage base, float red, float green, float blue, float threshold) {
		super.setCurrentSH(CHROMAKEY2);
		this.checkUVSettings(src, base, "srci");
		super.currentSH.set("keyColor", red/255.0f, green/255.0f, blue/255.0f);
		super.currentSH.set("threshold", threshold);
		super.currentSH.set("base", base);
		return super.filter(src);	
	}
	
	/**
	 * Chroma key on image with a border threshold of 0.5f. Return image with alpha 0.0
	 * @param src source layer
	 * @param red red component of the key color between [0 - 255]
	 * @param green green component of the key color between [0 - 255]
	 * @param blue blue component of the key color between [0 - 255]
	 * @return
	 */
	public PGraphics getChromaKeyImage(PImage src, float red, float green, float blue) {
		super.setCurrentSH(CHROMAKEY);
		super.currentSH.set("keyColor", red/255.0f, green/255.0f, blue/255.0f);
		super.currentSH.set("threshold", 0.5f);
		return super.filter(src);	
	}
	
	/**
	 * Chroma key on image. Return image with alpha 0.0
	 * @param src source layer
	 * @param red red component of the key color between [0 - 255]
	 * @param green green component of the key color between [0 - 255]
	 * @param blue blue component of the key color between [0 - 255]
	 * @param threshold border threshold between [0.0, 1.0]
	 * @return
	 */
	public PGraphics getChromaKeyImage(PImage src, float red, float green, float blue, float threshold) {
		super.setCurrentSH(CHROMAKEY);
		super.currentSH.set("keyColor", red/255.0f, green/255.0f, blue/255.0f);
		super.currentSH.set("threshold", threshold);
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
	 * Overlay blending
	 * @param src source layer to blend
	 * @param base base layer
	 * @param opacity opacity of the src blended layer on the base layer between 0/100
	 * @return
	 */
	public PGraphics getBlendOverlayImage(PImage src, PImage base, float opacity) {
		return getBlendImage(src, base, opacity, GPUImageInterface.OVERLAY);
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
		this.checkUVSettings(src,  base, "srci");
		super.currentSH.set("base", base);
		super.currentSH.set("opacity", opacity/100.0f);
		return super.filter(src);
	}
}