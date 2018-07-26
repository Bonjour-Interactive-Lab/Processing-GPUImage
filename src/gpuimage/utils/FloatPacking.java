package gpuimage.utils;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * FloatPacking is an utils class allowing to packing floating point value (double and float) into RGBA texture.<br>
 * This technic is usefull when you need to pass and array of values from CPU to GPU for vairous GPGPU computation on shader side — 
 * such as physics simulation on pixel analysis like optical flow — or if you need to send large amount of data as texture (using spout, syphon or NDI)<br>
 * 
 * <p>
 * The main idea is to take a floating point value (double or float) on a range 0-1 and split/encode it into 16, 24 or 32 bits as color where :<br>
 * <ul>
 * <li><b>16 bits</b> : the value is encoded into Red and Green (8 bits per channel). <b>255 * 255</b></li>
 * <li><b>24 bits</b>  : the value is encoded into Red, Green and Blue (8 bits per channel). <b>255 * 255 * 255</b></li>
 * <li><b>32 bits</b>  : the value is encoded into Red, Green, Blue and Alpha (8 bits per channel). <b>255 * 255 * 255 * 255</b></li>
 * </ul>
 * <p>
 * The more you split your value between the RGBA channels the more precision you will get when retrieving values
 * <p><b>All color are send as int.</b> You can use it with the processing variable color</p>
 * <p> the value can be retreived on CPU side via the provided methods or en GPU (shader) side via the following methods :
 * <pre>
 * {@code
 *#version 150
*#ifdef GL_ES
*precision highp float;
*precision highp vec4;
*precision highp vec3;
*precision highp vec2;
*precision highp int;
*#endif
*
* //constants elements
*const vec4 efactor = vec4(1.0, 255.0, 65025.0, 16581375.0);
*const vec4 dfactor = vec4(1.0/1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
*const float mask = 1.0/256.0;
*
*
*uniform sampler2D texture;
*
*in vec4 vertTexCoord;
*out vec4 fragColor;
*
*vec4 encodeRGBA32(float v){
*	vec4 rgba = v * efactor.rgba;
*	rgba.gba = fract(rgba.gba);
*	rgba.rgb -= rgba.gba * mask;
*	rgba.a = 1.0;
*	return rgba;
*}
*
*vec4 encodeRGBA24(float v){
*	vec3 rgb = v * efactor.rgb;
*	rgb.gb = fract(rgb.gb);
*	rgb.rg -= rgb.gb * mask;
*	return vec4(rgb, 1.0);
*}
*
*vec4 encodeRGBA16(float v){
*	vec2 rg = v * efactor.rg;
*	rg.g = fract(rg.g);
*	rg.r -= rg.g * mask;
*	return vec4(rg, 0.0, 1.0);
*}
*
*float decodeRGBA32(vec4 rgba){
*	return dot(rgba, dfactor.rgba);
*}
*
*float decodeRGBA24(vec3 rgb){
*	return dot(rgb, dfactor.rgb);
*}
*
*float decodeRGBA16(vec2 rg){
*	return dot(rg, dfactor.rg);
*}
*
*
*void main(){
*	vec2 uv = vertTexCoord.xy;
*	vec4 tex = texture2D(texture, uv);
*
*	float data = decodeRGBA32(tex);
*	vec4 encodedData = encodeRGBA32(data);
*
*	fragColor = encodedData;
*} 
 * }
 * </pre>
 * @see GPUImageInterface
 * @author bonjour
 *
 */
public class FloatPacking extends GPUImageBaseFloatPacking{
	
	public FloatPacking(PApplet papplet) {
		super(papplet);
	}
	
	/* ...............................................
	 * 
	 * 
	 * 		Value encoding to ARGB
	 * 
	 * 
	 ...............................................*/
	
	/**
	 * Encodes a double array into a desired RBGA texture format such as : 
	 * ARGB16 : R×G
	 * ARGB24 : R×G×B
	 * ARGB32 : R×G×B×A
	 * This methods can slow the process by using a switch/case method
	 * @param value
	 * @param ENCODINGTYPE
	 * @return
	 */
	public PImage encodeARGBDouble(double[] data, int ENCODINGTYPE) {
		/**
		 * Switch case are quite slow. We kept it in order to propose a custom solution but for faster encoding please use direct implementation
		 */
		this.paramEncodedDataImage(data.length);	
		switch(ENCODINGTYPE) {
			default :
			case GPUImageInterface.ARGB32 : this.encodeARGB32(data);
			break;
			case GPUImageInterface.ARGB24 : this.encodeARGB24(data);
			break;
			case GPUImageInterface.ARGB16 : this.encodeARGB16(data);
			break;
		}
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a double array into a desired RBGA32 texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB32Double(double[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB32(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a double array into a desired RBGA24 texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB24Double(double[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB24(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a double array into a desired RBGA16 texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB16Double(double[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB16(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a float array into a desired RBGA texture format such as : 
	 * ARGB16 : R×G
	 * ARGB24 : R×G×B
	 * ARGB32 : R×G×B×A
	 * This methods can slow the process by using a switch/case method
	 * @param value
	 * @param ENCODINGTYPE
	 * @return
	 */
	public PImage encodeARGBFloat(float[] data, int ENCODINGTYPE) {
		this.paramEncodedDataImage(data.length);
		switch(ENCODINGTYPE) {
			default :
			case GPUImageInterface.ARGB32 : this.encodeARGB32(data);
			break;
			case GPUImageInterface.ARGB24 : this.encodeARGB24(data);
			break;
			case GPUImageInterface.ARGB16 : this.encodeARGB16(data);
			break;
		}
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a float array into a desired RBGA32 texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB32Float(float[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB32(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a float array into a desired RBGA24 texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB24Float(float[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB24(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	/**
	 * Encodes a float array into a desired RBGA16 texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB16Float(float[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB16(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	//encoding data RGBA 32/24/16
	private void encodeARGB32(double[] data) {
		for(int i=0; i<data.length; i++){
			double value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.doubleToARGB32(value);
			imagePixelData[i] = encodedData;
		}
	}
	
	private void encodeARGB32(float[] data) {
		for(int i=0; i<data.length; i++){
			float value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.floatToARGB32(value);
			imagePixelData[i] = encodedData;
		}
	}
	
	private void encodeARGB24(double[] data) {
		for(int i=0; i<data.length; i++){
			double value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.doubleToARGB24(value);
			imagePixelData[i] = encodedData;
		}
	}
	
	private void encodeARGB24(float[] data) {
		for(int i=0; i<data.length; i++){
			float value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.floatToARGB24(value);
			imagePixelData[i] = encodedData;
		}
	}
	
	private void encodeARGB16(double[] data) {
		for(int i=0; i<data.length; i++){
			double value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.doubleToARGB16(value);
			imagePixelData[i] = encodedData;
		}
	}
	
	private void encodeARGB16(float[] data) {
		for(int i=0; i<data.length; i++){
			float value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.floatToARGB16(value);
			imagePixelData[i] = encodedData;
		}
	}
	
	/** ...............................................
	 * 
	 * 
	 * 		Value decoding from ARGB
	 * 
	 * 
	 ...............................................*/	
	
	/**
	 * Decode a RGBA texture from a selected format as double array. Format can be :
	 * ARGB16 : R×G
	 * ARGB24 : R×G×B
	 * ARGB32 : R×G×B×A
	 * This methods can slow the process by using a switch/case method 
	 * @param img
	 * @param ENCODINGTYPE
	 * @return
	 */
	public double[] decodeARGBDouble(PImage img, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : return this.decodeARGB32Double(img);
			case GPUImageInterface.ARGB24 : return this.decodeARGB24Double(img);
			case GPUImageInterface.ARGB16 : return this.decodeARGB16Double(img);
			default : return this.decodeARGB32Double(img);
		}
	}
	
	/**
	 * Decode a RGBA texture from a selected format as float array. Format can be :
	 * ARGB16 : R×G
	 * ARGB24 : R×G×B
	 * ARGB32 : R×G×B×A
	 * This methods can slow the process by using a switch/case method 
	 * @param img
	 * @param ENCODINGTYPE
	 * @return
	 */
	public float[] decodeARGBFloat(PImage img, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : return this.decodeARGB32Float(img);
			case GPUImageInterface.ARGB24 : return this.decodeARGB24Float(img);
			case GPUImageInterface.ARGB16 : return this.decodeARGB16Float(img);
			default : return this.decodeARGB32Float(img);
		}
	}
	
	/**
	 * Decode a RGBA32 texture as double array.
	 * @param img
	 * @return
	 */
	public double[] decodeARGB32Double(PImage img) {
		double[] datas = setDoubleArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB32ToDouble(argb);
		}
		return datas;
	}
	
	/**
	 * Decode a RGBA32 texture as float array.
	 * @param img
	 * @return
	 */
	public float[] decodeARGB32Float(PImage img) {
		float[] datas = setFloatArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB32ToFloat(argb);
		}
		return datas;
	}
	
	/**
	 * Decode a RGBA24 texture as double array.
	 * @param img
	 * @return
	 */
	public double[] decodeARGB24Double(PImage img) {
		double[] datas = setDoubleArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB24ToDouble(argb);
		}
		return datas;
	}
	
	/**
	 * Decode a RGBA24 texture as float array.
	 * @param img
	 * @return
	 */
	public float[] decodeARGB24Float(PImage img) {
		float[] datas = setFloatArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB24ToFloat(argb);
		}
		return datas;
	}
	
	/**
	 * Decode a RGBA16 texture as double array.
	 * @param img
	 * @return
	 */
	public double[] decodeARGB16Double(PImage img) {
		double[] datas = setDoubleArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB16ToDouble(argb);
		}
		return datas;
	}
	
	/**
	 * Decode a RGBA16 texture as float array.
	 * @param img
	 * @return
	 */
	public float[] decodeARGB16Float(PImage img) {
		float[] datas = setFloatArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB16ToFloat(argb);
		}
		return datas;
	}
	
	//set datas arrays
	private double[] setDoubleArray(PImage img) {
		img.loadPixels();
		double[] datas = new double[img.pixels.length];
		return datas;
	}
	
	private float[] setFloatArray(PImage img) {
		img.loadPixels();
		float[] datas = new float[img.pixels.length];
		return datas;
	}

}