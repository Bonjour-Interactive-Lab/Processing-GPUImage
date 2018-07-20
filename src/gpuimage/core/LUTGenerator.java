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
public class LUTGenerator extends GPUImageBaseEffects{
	public LUTGenerator(PApplet papplet) {
		super.init(papplet, 512, 512);
	}
	
	/** Draw the PPB with filter*/
	protected void ppbFilter(PShader filtersrc) {
		this.ppb.dst.beginDraw();
		this.ppb.dst.background(0);
		this.ppb.dst.shader(filtersrc);
		this.ppb.dst.noStroke();
		this.ppb.dst.rect(0, 0, this.ppb.dst.width, this.ppb.dst.height);
		this.ppb.dst.endDraw();
	}
	
	/** Apply Filter*/
	protected PGraphics filter() {
		//check if papplet exist
		if(this.ppb != null && this.ppb.dst.width == 512 && this.ppb.dst.height == 512) {
		}else {
			//or init
			this.initBase(this.papplet, 512, 512);
		}
		
		//apply filter
		this.ppbFilter(this.currentSH);

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
	
	public PGraphics generateLUT1D() {
		super.setCurrentSH(LUT1DGEN);
		return this.filter();
	}
}