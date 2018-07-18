package gpuimage.utils;
import java.awt.image.BufferedImage;


import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * 
 * @author bonjour
 *
 */
public class Vec2Packing extends GPUImageBaseFloatPacking{

	
	public Vec2Packing(PApplet papplet){
		super(papplet);
	}
	
	public PImage encodeARGB(PVector[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB16(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	private void encodeARGB16(PVector[] data) {
		for(int i=0; i<data.length; i++){
			PVector value = data[i];
			//if(data > 1.0) println("WARNING DATA " +i+" : "+data +" IS NOT NORMALIZED");
			float[] encodedDataX = super.valueToARGB16(value.x);
			float[] encodedDataY = super.valueToARGB16(value.y);
			float[] encodedRGBA = {encodedDataX[0], encodedDataX[1], encodedDataY[0], encodedDataY[1]};
			int encodedData = GPUImage.getARGB(encodedRGBA);
			imagePixelData[i] = encodedData;
		}
	}
	
	public PVector[] decodeARGB(PImage img) {
		PVector[] datas = setVectorArray(img);
		for(int i=0; i<datas.length; i++) {
			float[] rgba = GPUImage.getRGBAFloat(img.pixels[i]);
			int argbX = 255 << 24 | (int)rgba[0] << 16 | (int)rgba[1] << 8 | 255;
			int argbY = 255 << 24 | (int)rgba[2] << 16 | (int)rgba[3] << 8 | 255;
			PVector vector = new PVector();
			vector.x = super.ARGB16ToFloat(argbX);
			vector.y = super.ARGB16ToFloat(argbY);
			datas[i] = vector;
		}
		return datas;
	}
	

	private PVector[] setVectorArray(PImage img) {
		img.loadPixels();
		PVector[] datas = new PVector[img.pixels.length];
		return datas;
	}
	
}