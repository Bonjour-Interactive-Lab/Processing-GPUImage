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
	
	
	//FILTERS
	public PGraphics getBilateralImage(PImage src) {
		this.checkIfShaderExists(BILATERAL);
		currentSH = shaderlist.get(BILATERAL);
		return filter(this.papplet, src, currentSH);
	}
}