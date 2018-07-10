package gpuimage.core;

import java.util.HashMap;
import gpuimage.utils.*;
import processing.core.*;
import processing.opengl.*;
import processing.opengl.PGraphicsOpenGL;

public class Filter implements GPUFiltersInterface, PConstants{
	public static final String SHADERPATH = "/data/shaders/";
	
	private PApplet papplet;
	private PingPongBuffer ppb;
	private HashMap<String, PShader> shaderlist = new HashMap<String, PShader>();
	
	private void initPPB(PApplet papplet, int width, int height) {
		if(this.papplet == null) {
			this.papplet = papplet;
		}
		
		this.ppb = new PingPongBuffer(this.papplet, width, height);
	}
	
	public PGraphics filter(PApplet papplet, PImage src, PShader filtersrc) {
		//check if papplet exist
		if(this.ppb != null && this.ppb.dst.width == src.width && this.ppb.dst.height == src.height) {
		}else {
			//or init
			this.initPPB(papplet, src.width, src.height);
		}
		
		this.ppbFilter(papplet, src, filtersrc);
		
		//return a clone of the PGraphics
		try {
			return (PGraphics) this.ppb.dst.clone();
		}catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	private void ppbFilter(PApplet papplet, PImage src, PShader filtersrc) {
		this.ppb.dst.beginDraw();
		this.ppb.dst.background(0);
		this.ppb.dst.shader(filtersrc);
		this.ppb.dst.image(src, 0, 0);
		this.ppb.dst.endDraw();
		
		//swap buffer for next iteration
		this.ppb.swap();
	}
}