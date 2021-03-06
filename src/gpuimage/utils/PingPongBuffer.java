package gpuimage.utils;

import gpuimage.core.GPUImageInterface;
import processing.core.*;
import processing.opengl.PGraphicsOpenGL;

/**
 * PingPong buffer is an utils class allowing you to create a ping pong buffer in order to make read-write texture pipeline by creating 2 buffers<br>
 * Each buffer can be swapped so the second is always a previous version of the first one.<br>
 * 
 * The main idea of this class is to keep the paradigm of an offscreen buffer made in processing using PGraphics through the PinPongBuffer object. <br>
 * So user does not have to learn an new offscreen drawing implementation with various context and drawing methods. Drawing can be handle using :
 * <pre>
 * {@code
 * object.dst.beginDraw();
 * //...draw anything you like using buffer.function()
 * object.dst.endDraw();
 * object.swap(); //swap buffer
 * }
 * </pre>
 * 
 * @author bonjour
 * @see GPUImageInterface
 *
 */
public class PingPongBuffer implements PConstants{
	private PApplet papplet;
	private PGraphics src;
	public PGraphics dst;

	/**
	 * Instantiate a Ping Pong Buffer Object at the size of the PApplet  (RENDERER is java2d)
	 * @param papplet
	 */
	public PingPongBuffer(PApplet papplet) {
		initBuffers(papplet, papplet.width, papplet.height, null);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object at the size of the PApplet 
	 * @param papplet
	 * @param RENDERER
	 */
	public PingPongBuffer(PApplet papplet, String RENDERER) {
		initBuffers(papplet, papplet.width, papplet.height, RENDERER);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object at the size of the PApplet and smooth (RENDERER is java2d)
	 * @param papplet
	 * @param smooth
	 */
	public PingPongBuffer(PApplet papplet, int smooth) {
		initBuffers(papplet, papplet.width, papplet.height, null, smooth);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object at the size of the PApplet and smooth
	 * @param papplet
	 * @param smooth
	 * @param RENDERER
	 */
	public PingPongBuffer(PApplet papplet, int smooth, String RENDERER) {
		initBuffers(papplet, papplet.width, papplet.height, RENDERER, smooth);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object with custom size (renderer is java2d)
	 * @param papplet
	 * @param width
	 * @param height
	 */
	public PingPongBuffer(PApplet papplet, int width, int height) {
		initBuffers(papplet, width, height, null);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object with custom size 
	 * @param papplet
	 * @param width
	 * @param height
	 */
	public PingPongBuffer(PApplet papplet, int width, int height, String RENDERER) {
		initBuffers(papplet, width, height, RENDERER);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object with custom size and smooth (RENDERER is java2d)
	 * @param papplet
	 * @param width
	 * @param height
	 * @param smooth
	 */
	public PingPongBuffer(PApplet papplet, int width, int height, int smooth) {
		initBuffers(papplet, width, height, null, smooth);
	}
	
	/**
	 * Instantiate a Ping Pong Buffer Object with custom size and smooth (RENDERER is java2d)
	 * @param papplet
	 * @param width
	 * @param height
	 * @param smooth
	 * @param RENDERER
	 */
	public PingPongBuffer(PApplet papplet, int width, int height, int smooth, String RENDERER) {
		initBuffers(papplet, width, height, RENDERER, smooth);
	}
	
	/**
	 * Init the buffers
	 * @param papplet
	 * @param width
	 * @param height
	 * @param RENDERER
	 */
	private void initBuffers(PApplet papplet, int width, int height, String RENDERER, int smooth) {
		this.initBuffers(papplet, width, height, RENDERER);
		this.smooth(smooth);
	}
	
	private void initBuffers(PApplet papplet, int width, int height, String RENDERER) {
		this.papplet = papplet;
		if(RENDERER != null) {
			this.dst = papplet.createGraphics(width, height, RENDERER);
			this.src = papplet.createGraphics(this.dst.width, this.dst.height, RENDERER);
		}else {
			this.dst = papplet.createGraphics(width, height);
			this.src = papplet.createGraphics(this.dst.width, this.dst.height);
		}
	}
	
	/**
	 * Swap the buffer for the next iteration
	 */
	public void swap() {
		PGraphics tmp = this.src;
		this.src = this.dst;
		this.dst = tmp;
	}
	
	private void dispose() {
		this.src.dispose();
		this.dst.dispose();
	}
	
	/**
	 * Clear the buffer
	 */
	public void clear() {
		this.src.beginDraw();
		this.src.clear();
		this.src.endDraw();
		
		this.dst.beginDraw();
		this.dst.clear();
		this.dst.endDraw();
	}
	
	/**
	 * Change the texture filtering mode as :
	 * NEAREST
	 * LINEAR
	 * BILINEAR
	 * TRILINEAR
	 * @param FILTERING
	 */
	public void setFiltering(int FILTERING) {
		switch(FILTERING) {
		default :
		case GPUImageInterface.NEAREST : 
			((PGraphicsOpenGL)this.src).textureSampling(2) ;
			((PGraphicsOpenGL)this.dst).textureSampling(2) ;
			break;
		case GPUImageInterface.LINEAR :
			((PGraphicsOpenGL)this.src).textureSampling(3) ;
			((PGraphicsOpenGL)this.dst).textureSampling(3) ;
			break;
		case GPUImageInterface.BILINEAR :
			((PGraphicsOpenGL)this.src).textureSampling(4) ;
			((PGraphicsOpenGL)this.dst).textureSampling(4) ;
			break;
		case GPUImageInterface.TRILINEAR :
			((PGraphicsOpenGL)this.src).textureSampling(5) ;
			((PGraphicsOpenGL)this.dst).textureSampling(5) ;
			break;
		}
	}
	
	/**
	 * Activate aliasing on the ping-pong buffer.
	 * See reference on Processing for more informations : https://processing.org/reference/smooth_.html
	 * @param smooth can be either 2, 3, 4 or 8. Default is 4
	 */
	public void smooth(int smooth) {
		this.dst.smooth(smooth);
		this.src.smooth(smooth);
	}
	
	/**
	 * Desactivate aliasing on the buffers
	 */
	public void noSmooth() {
		this.dst.noSmooth();
		this.src.noSmooth();
	}
	
	/**
	 * Enable/disable texture mipmap
	 * @param state
	 */
	public void enableTextureMipmaps(boolean state) {
		if(state) {
			this.src.hint(ENABLE_TEXTURE_MIPMAPS);
			this.dst.hint(ENABLE_TEXTURE_MIPMAPS);
		}else {
			this.src.hint(DISABLE_TEXTURE_MIPMAPS);
			this.dst.hint(DISABLE_TEXTURE_MIPMAPS);
		}
	}
	
	/**
	 * return the Source Buffer
	 * @return
	 */
	public PGraphics getSrcBuffer() {
		return this.src;
	}
	
	/***
	 * retrun the Destination Buffer
	 * @return
	 */
	public PGraphics getDstBuffer() {
		return  this.dst;
	}
}