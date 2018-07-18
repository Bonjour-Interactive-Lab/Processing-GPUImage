package gpuimage.utils;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * Integer to rgba packing using RGB 8bit for value as v%255.0 and 8bits for modulo index as i = (a / 256) * divider where divider is a known value
 * @author bonjour
 *
 */
public class IntPacking{
	private PApplet papplet;
	private PImage encodedDataImage;
	private BufferedImage image;
	private int[] imagePixelData;
	private float divider;
	
	public IntPacking(PApplet papplet) {
		this.papplet = papplet;
	}
	
	private void paramEncodedDataImage(int dataLength) {
		int[] wh = GPUImage.getWidthHeightFromArea(dataLength);	
		image = new BufferedImage(wh[0], wh[1], BufferedImage.TYPE_INT_ARGB);
		imagePixelData = ((DataBufferInt)image.getRaster().getDataBuffer()).getData();
	}
	
	public PImage encodeARGB(int[] datas, int maxDataValue) {
		paramEncodedDataImage(datas.length);
		divider = maxDataValue / 256.0f;
		encodeARGBMod(datas);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	private void encodeARGBMod(int[] datas) {
		for(int i=0; i<datas.length; i++){
			int value = datas[i];
			int modValue = value % 255;
			int modIndex = value / 255;
			int modIndexAlpha = Math.round(((float)modIndex / divider) * 255);
			imagePixelData[i] = (modIndexAlpha << 24) | (modValue << 16) | (modValue << 8) | modValue;
		}
	}
	
	public int[] decodeARGB(PImage img, int maxDataValue) {
		img.loadPixels();
		float divider = maxDataValue / 256.0f;
		int[] datas = new int[img.width * img.height];
		for(int i=0; i<datas.length; i++) {
			int a = img.pixels[i] >> 24 & 0xFF;
			int r = img.pixels[i] >> 16 & 0xFF;
			
			int modIndexRetreived = Math.round((a / 255.0f) * divider);
			datas[i] = (r + 255 * modIndexRetreived);
		}
		
		return datas;
	}
	
	public float getLastDivider() {
		return this.divider;
	}
	
}