package gpuimage.utils;

import gpuimage.core.GPUImageInterface;
import processing.core.*;
import processing.opengl.Texture;
import processing.opengl.PGraphicsOpenGL;
/**
 * Based on GoToLoop PGraphicsJava2D extended class example : https://forum.processing.org/two/discussion/5238/creating-a-layer-class-that-extends-pgraphics
 * @author bonjour
 *
 */
public class PingPongGraphics extends PGraphicsOpenGL implements PConstants, GPUImageInterface{
	/*public PingPongGraphics src;
	public PingPongGraphics dst;
	public PingPongGraphics[] swapArray;*/
	public PGraphicsOpenGL dst, src;
	public PImage srcTex;
	private PApplet papplet;
	
	/*see getEnclosingPApplet() method which return an error
	public PingPongGraphics(int width, int height) {
		final PApplet papplet = getEnclosingPApplet();
		init(papplet, width, height, papplet.dataPath(""), true);
	}*/
	
	public PingPongGraphics(PApplet papplet, int width, int height) {
		init(papplet, width, height, papplet.dataPath(""), true);
	}
	
	public PingPongGraphics(PApplet papplet, int width, int height, String datapath) {
		init(papplet, width, height, datapath, true);
	}
	
	private PingPongGraphics(PApplet papplet, int width, int height, String datapath, boolean ext) {
		init(papplet, width, height, datapath, ext);
	}
	
	private void init(PApplet papplet, int width, int height, String datapath, boolean ext) {
		this.papplet = papplet;
		//set param & init
		setParent(this.papplet);
		setPrimary(false);
		setPath(datapath);
		setSize(width, height);
		smooth(8);
		this.dst = this;
		src = (PGraphicsOpenGL) this.papplet.createGraphics(this.width, this.height, P2D);
		srcTex = new PImage(this.width, this.height, ARGB);
		/*this.swapArray = new PingPongGraphics[2];
		
		if(ext) {
			//create the second buffer;
			this.src = new PingPongGraphics(this.papplet, width, height, this.papplet.dataPath(""), false);
		}
	
		this.swapArray[0] = this.src;
		this.swapArray[1] = this.dst;*/
	}
	
	public void swap() {
		/*
		//write into texture : great solution for now
		this.src.beginDraw();
		this.src.background(255, 0, 0);
		this.src.image(this.dst, 0, 0, width, height);
		this.src.endDraw();
		*/
		/*
		//copy the destination buffer to the source buffer : too many call result low perf
		dst.loadPixels();
		src.loadPixels();
		PApplet.arrayCopy(dst.pixels, src.pixels);
		src.updatePixels();
		*/
		/*
		//swapping Array
		PingPongGraphics tmp = this.swapArray[0];
		this.swapArray[0] = this.swapArray[1];
		this.swapArray[1] = tmp;
		*/
		/*
		//swapping object
		PingPongGraphics tmp = this.src.dst;
		this.src.dst = this.dst;
		this.dst = tmp;
		*/
		/*
		//get the texture attach to the buffer in order to send it to the src buffer
		loadTexture();
		
		if(filterTexture == null) {// || filterTexture.contextIsOutdated()){
			filterTexture = new Texture(this.dst, texture.width, texture.height, texture.getParameters());
			filterTexture.invertedY(true);
			filterImage = wrapTexture(filterTexture);
		}
		filterTexture.set(texture);
		src.textureMode = NORMAL;
		
		
		src.beginDraw();
		src.beginShape(QUADS);
		src.texture(filterImage);
		src.vertex(0, 0, 0, 0);
		src.vertex(src.width, 0, 1, 0);
		src.vertex(src.width, src.height, 1, 1);
		src.vertex(0, src.height, 0, 1);
		src.endShape();
		src.endDraw();
		*/
		
		// get only the texture as PImage
		
		loadTexture();
		if(filterTexture == null) {// || filterTexture.contextIsOutdated()){
			filterTexture = new Texture(this.dst, texture.width, texture.height, texture.getParameters());
			filterTexture.invertedY(true);
			filterImage = wrapTexture(filterTexture);
		}
		filterTexture.set(texture);
		this.srcTex = filterImage;
		

		//this.srcTex = textureImage;
	}
	
	
	/**
	 * this seems to return an error
	 * @return
	 */
	/*
	protected PApplet getEnclosingPApplet() {
		try {
			return (PApplet) getClass()
					.getDeclaredField("this$0").get(this);
		}catch(ReflectiveOperationException roe) {
			throw new RuntimeException(roe);
		}
	}
	*/
	
	public PImage getSrcBuffer() {
		//return this.src;
		return this.srcTex;
	}
	
	@Override public String toString() {
		return "PingPongGraphics:\n Width: "+width+"\nHeight: "+height+"\nPath: "+path;
	}
}