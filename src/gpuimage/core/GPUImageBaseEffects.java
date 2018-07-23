package gpuimage.core;

import java.nio.file.Paths;
import java.util.HashMap;
import gpuimage.utils.*;
import processing.core.*;
import processing.opengl.*;

/**
 * GPUImageBaseEffects is the abstract class of filter and effect. 
 * It defines the filtering methods using a PingPong buffer in order to have a read-write texture and allowing to stack filter on the same layer
 * @author bonjour
 */
abstract class GPUImageBaseEffects implements GPUImageInterface, PConstants{
	/** Path to the shaders*/
	protected static final String SHADERPATH = "shaders/";
	
	/** Processing Context */
	protected PApplet papplet;
	
	/**PingPong buffer (based on the first implementation, view readme on github for more informations)*/
	protected PingPongBuffer ppb;
	
	/**Current shader used*/
	protected PShader currentSH = new PShader();
	
	/**List of all available shaders*/
	protected HashMap<String, PShader> shaderlist = new HashMap<String, PShader>();
	
	//---------------------------------------------------------
	
	/**Init methods creating PPB and defining context*/
	public void init(PApplet papplet) {
		this.init(papplet, papplet.width, papplet.height);
	}
	
	public void init(PApplet papplet, int width, int height) {
		this.initBase(papplet, width, height);
	}
	
	protected void initBase(PApplet papplet, int width, int height) {
		if(this.papplet == null) {
			this.papplet = papplet;
		}
		this.ppb = new PingPongBuffer(this.papplet, width, height);
	}
	
	/**Load shader and add it to the hashmap*/
	protected void loadShader(String src) {
		PShader sh = this.papplet.loadShader(SHADERPATH+src+".glsl");
		shaderlist.put(src, sh);
	}
	
	/**Check if a shader is available or need to be loaded*/
	protected void checkIfShaderExists(String name) {
		if(shaderlist.containsKey(name)) {
		}else {
			this.loadShader(name);
		}
	}
	
	/** Draw the PPB with filter*/
	protected void ppbFilter(PImage src, PShader filtersrc) {
		this.ppb.dst.beginDraw();
		this.ppb.dst.background(0);
		this.ppb.dst.shader(filtersrc);
		this.ppb.dst.image(src, 0, 0);
		this.ppb.dst.endDraw();
	}
	
	/** Apply Filter*/
	protected PGraphics filter(PImage src) {
		//check if papplet exist
		if(this.ppb != null && this.ppb.dst.width == src.width && this.ppb.dst.height == src.height) {
		}else {
			//or init
			this.initBase(this.papplet, src.width, src.height);
		}
		
		//apply filter
		this.ppbFilter(src, this.currentSH);

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
	
	//check type
	protected boolean isPImage(PImage src) {
		if(src instanceof PGraphics) {
			return false;
		}else {
			return true;
		}
	}
	
	/**Set current shader*/
	protected void setCurrentSH(String NAME) {
		this.checkIfShaderExists(NAME);
		currentSH = shaderlist.get(NAME);
	}
	
	/**Use a custom shader outside of the library*/
	public PGraphics getCustomFilter(PImage src, PShader customFilter) {
		currentSH = customFilter;
		return filter(src);
	}
	
	/** Get the screen coordinate UV on the image for debugging*/
	public PGraphics getUV(PImage src) {
		this.setCurrentSH(UV);
		currentSH.set("resolution", (float)src.width, (float)src.height);
		return filter(src);
	}
}