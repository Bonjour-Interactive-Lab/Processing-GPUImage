package gpuimage.utils;

import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * @author bonjour
 *
 */
public class FloatPacking extends GPUImageBaseFloatPacking{
	private PApplet papplet;
	private PImage encodedDataImage;
	/*private int numberOfUnusedPixels;
	private int numberOfUsedPixels;
	private int encodedNumberOfUsedPixels;
	private double decodedNumberOfUsedPixels;
	private int datalength;*/
	
	public FloatPacking(PApplet papplet) {
		this.papplet = papplet;
		initEncodedDataImage();
	}
	
	private void initEncodedDataImage() {
		encodedDataImage = this.papplet.createImage(100, 100, PConstants.ARGB);
	}
	
	private void paramEncodedDataImage(int width, int height) {
		encodedDataImage.resize(width, height);
		encodedDataImage.loadPixels();
	}
	
	public void paramEncodedDataImage(int dataLength) {
		double sqrtDataLength = Math.sqrt((double)dataLength);
		int ediWidth = (int)Math.ceil(sqrtDataLength);
		//numberOfUnusedPixels = (int)Math.ceil(ediWidth * ediWidth - sqrtDataLength * sqrtDataLength) - 1; //We substract 1 to the unused pixel because we encode the number of data into the first one
		//numberOfUsedPixels = dataLength; //then the number of used pixels = data length + first pixel which encode the number of data
		
		/**
		 * lossy precission...not usefull. Find a way to replace the squared texture by a rectangular one
		 */
		//double normPixelsUsed = (double) dataLength / sqrtDataLength;
		//encodedNumberOfUsedPixels = super.valueToARGB(normPixelsUsed, GPUImageInterface.ARGB32);
		
		//System.out.println("The following coded texture will have "+numberOfUnusedPixels+" unused pixels");		
		this.paramEncodedDataImage(ediWidth, ediWidth);
	}
	
	
	/** ...............................................
	 * 
	 * 
	 * 		Value encoding to ARGB
	 * 
	 * 
	 ...............................................*/
	
	public PImage encodeRGBADouble(double[] data, int ENCODINGTYPE) {
		this.paramEncodedDataImage((int)data.length);
		//encodedDataImage.pixels[0] = encodedNumberOfUsedPixels; //we feed the first pixel with the amount of encoded pixels as ARGB32 for high precision
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : this.encodeARGB32(data);
			case GPUImageInterface.ARGB24 : this.encodeARGB24(data);
			case GPUImageInterface.ARGB16 : this.encodeARGB16(data);
			default : this.encodeARGB32(data);
		}
		return encodedDataImage;
	}
	
	public PImage encodeRGBAFloat(float[] data, int ENCODINGTYPE) {
		this.paramEncodedDataImage((int)data.length);
		//encodedDataImage.pixels[0] = encodedNumberOfUsedPixels; //we feed the first pixel with the amount of encoded pixels as ARGB32 for high precision
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : this.encodeARGB32(data);
			case GPUImageInterface.ARGB24 : this.encodeARGB24(data);
			case GPUImageInterface.ARGB16 : this.encodeARGB16(data);
			default : this.encodeARGB32(data);
		}
		return encodedDataImage;
	}
	
	private void encodeARGB32(double[] data) {
		for(int i=0; i<data.length; i++){
			double value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.valueToARGB(value, GPUImageInterface.ARGB32);
			encodedDataImage.pixels[i] = encodedData; //we encode the pixel n+1 beacause the first pixel is already used
		}
		encodedDataImage.updatePixels();
	}
	
	private void encodeARGB32(float[] data) {
		for(int i=0; i<data.length; i++){
			float value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.valueToARGB(value, GPUImageInterface.ARGB32);
			encodedDataImage.pixels[i] = encodedData; //we encode the pixel n+1 beacause the first pixel is already used
		}
		encodedDataImage.updatePixels();
	}
	
	private void encodeARGB24(double[] data) {
		for(int i=0; i<data.length; i++){
			double value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.valueToARGB(value, GPUImageInterface.ARGB24);
			encodedDataImage.pixels[i] = encodedData; //we encode the pixel n+1 beacause the first pixel is already used
		}
		encodedDataImage.updatePixels();
	}
	
	private void encodeARGB24(float[] data) {
		for(int i=0; i<data.length; i++){
			float value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.valueToARGB(value, GPUImageInterface.ARGB24);
			encodedDataImage.pixels[i] = encodedData; //we encode the pixel n+1 beacause the first pixel is already used
		}
		encodedDataImage.updatePixels();
	}
	
	private void encodeARGB16(double[] data) {
		for(int i=0; i<data.length; i++){
			double value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.valueToARGB(value, GPUImageInterface.ARGB16);
			encodedDataImage.pixels[i] = encodedData; //we encode the pixel n+1 beacause the first pixel is already used
		}
		encodedDataImage.updatePixels();
	}
	
	private void encodeARGB16(float[] data) {
		for(int i=0; i<data.length; i++){
			float value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			int encodedData = super.valueToARGB(value, GPUImageInterface.ARGB16);
			encodedDataImage.pixels[i] = encodedData; //we encode the pixel n+1 beacause the first pixel is already used
		}
		encodedDataImage.updatePixels();
	}
	
	/** ...............................................
	 * 
	 * 
	 * 		Value decoding from ARGB
	 * 
	 * 
	 ...............................................*/	
	
	public double[] decodeARGBDouble(PImage img, int ENCODINGTYPE) {
		img.loadPixels();
		//decodedNumberOfUsedPixels = super.ARGBToDouble(img.pixels[0], GPUImageInterface.ARGB32);
		//datalength = getDataLenth(img);
		double[] datas = new double[img.pixels.length];
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : this.decodeARGB32Double(img, datas);
			case GPUImageInterface.ARGB24 : this.decodeARGB24Double(img, datas);
			case GPUImageInterface.ARGB16 : this.decodeARGB16Double(img, datas);
			default : this.decodeARGB32Double(img, datas);
		}
		return datas;
	}
	
	public float[] decodeARGBFloat(PImage img, int ENCODINGTYPE) {
		img.loadPixels();
		//decodedNumberOfUsedPixels = super.ARGBToDouble(img.pixels[0], GPUImageInterface.ARGB32);
		//datalength = getDataLenth(img);
		float[] datas = new float[img.pixels.length];
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : this.decodeARGB32Float(img, datas);
			case GPUImageInterface.ARGB24 : this.decodeARGB24Float(img, datas);
			case GPUImageInterface.ARGB16 : this.decodeARGB16Float(img, datas);
			default : this.decodeARGB32Float(img, datas);
		}
		return datas;
	}
	
	private void decodeARGB32Double(PImage img, double[] datas) {
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGBToDouble(argb, GPUImageInterface.ARGB32);
		}
	}
	
	private void decodeARGB32Float(PImage img, float[] datas) {
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGBToFloat(argb, GPUImageInterface.ARGB32);
		}
	}
	
	private void decodeARGB24Double(PImage img, double[] datas) {
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGBToDouble(argb, GPUImageInterface.ARGB24);
		}
	}
	
	private void decodeARGB24Float(PImage img, float[]datas) {
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGBToFloat(argb, GPUImageInterface.ARGB24);
		}
	}
	
	private void decodeARGB16Double(PImage img, double[] datas) {
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGBToDouble(argb, GPUImageInterface.ARGB16);
		}
	}
	
	private void decodeARGB16Float(PImage img, float[] datas) {
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGBToFloat(argb, GPUImageInterface.ARGB16);
		}
	}
	
	/**
	 * GETTER
	 * 
	 */
	/*
	private int getDataLenth(PImage img) {
		return (int)Math.ceil(decodedNumberOfUsedPixels * img.pixels.length);
	}
	
	public int getNumberOfUnusedPixels() {
		return numberOfUnusedPixels;
	}
	
	public int getNumberOfUsedPixels(){
		return numberOfUsedPixels;
	}*/
}