package gpuimage.utils;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * @author bonjour
 *
 */
public class FloatPacking extends GPUImageBaseFloatPacking{
	
	public FloatPacking(PApplet papplet) {
		super(papplet);
	}
	
	/** ...............................................
	 * 
	 * 
	 * 		Value encoding to ARGB
	 * 
	 * 
	 ...............................................*/
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
	
	public PImage encodeARGB32Double(double[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB32(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	public PImage encodeARGB24Double(double[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB24(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	public PImage encodeARGB16Double(double[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB16(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
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
	

	
	public PImage encodeARGB32Float(float[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB32(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	public PImage encodeARGB24Float(float[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB24(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	public PImage encodeARGB16Float(float[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB16(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
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
	
	public double[] decodeARGBDouble(PImage img, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : return this.decodeARGB32Double(img);
			case GPUImageInterface.ARGB24 : return this.decodeARGB24Double(img);
			case GPUImageInterface.ARGB16 : return this.decodeARGB16Double(img);
			default : return this.decodeARGB32Double(img);
		}
	}
	
	public float[] decodeARGBFloat(PImage img, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case GPUImageInterface.ARGB32 : return this.decodeARGB32Float(img);
			case GPUImageInterface.ARGB24 : return this.decodeARGB24Float(img);
			case GPUImageInterface.ARGB16 : return this.decodeARGB16Float(img);
			default : return this.decodeARGB32Float(img);
		}
	}
	
	public double[] decodeARGB32Double(PImage img) {
		double[] datas = setDoubleArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB32ToDouble(argb);
		}
		return datas;
	}
	
	public float[] decodeARGB32Float(PImage img) {
		float[] datas = setFloatArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB32ToFloat(argb);
		}
		return datas;
	}
	
	public double[] decodeARGB24Double(PImage img) {
		double[] datas = setDoubleArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB24ToDouble(argb);
		}
		return datas;
	}
	
	public float[] decodeARGB24Float(PImage img) {
		float[] datas = setFloatArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB24ToFloat(argb);
		}
		return datas;
	}
	
	public double[] decodeARGB16Double(PImage img) {
		double[] datas = setDoubleArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB16ToDouble(argb);
		}
		return datas;
	}
	
	public float[] decodeARGB16Float(PImage img) {
		float[] datas = setFloatArray(img);
		for(int i=0; i<datas.length; i++) {
			int argb = img.pixels[i];
			datas[i] = super.ARGB16ToFloat(argb);
		}
		return datas;
	}
	
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