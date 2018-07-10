package gpuimage.utils;
import processing.core.*;
import processing.opengl.PGraphicsOpenGL;

/**
 * PingPong buffer is an utils class allowing you to create a ping pong buffer in order to make read-write texture pipeline by creating 2 buffers
 * Each buffer can be swapped so the second is always a previous version of the first one.
 * 
 * The main idea of this class is to keep the paradigm of an offscreen buffer made in processing using PGraphics and bind this buffer to the PinPongBuffer object. 
 * So user does not have to learn an new offscreen drawing implementation with various context and drawing methods.
 * 
 * @author bonjour
 *
 */
public class PingPongBuffer implements PConstants{
	private PApplet papplet;
	private PGraphics src;
	private PGraphics dst;
	
	/**
	 * Create a PingPong buffer and bind the drawing buffer
	 * @param papplet
	 * @param dst
	 */
	public PingPongBuffer(PApplet papplet, PGraphics dst) {
		this.bindDestinationBuffer(papplet, dst);
	}
	
	/**
	 * Bind you drawing buffer to the PingPong buffer
	 * @param dst
	 */
	public void bindDestinationBuffer(PGraphics dst) {
		this.dst = dst;
	}
	
	/**
	 * Bind you drawing buffer to the PingPong buffer
	 * @param papplet
	 * @param dst
	 */
	private void bindDestinationBuffer(PApplet papplet, PGraphics dst) {
		this.papplet = papplet;
		this.dst = dst;
		this.src = papplet.createGraphics(this.dst.width, this.dst.height, P2D);
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
	
	public void clear() {
		this.src.clear();
		this.dst.clear();
	}
	
	/**
	 * return the Source Buffer
	 * @return
	 */
	public PGraphics getSourceBuffer() {
		return (PGraphics) this.src;
	}
	
	/***
	 * retrun the Destination Buffer
	 * @return
	 */
	public PGraphics getDestinationBuffer() {
		return  (PGraphics) this.dst;
	}
}