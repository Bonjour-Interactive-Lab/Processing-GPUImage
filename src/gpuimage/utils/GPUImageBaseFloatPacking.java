package gpuimage.utils;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * This class provide abilities to pack a float value into an RGBA texture.
 * You can then use it as an input for a shader or other such as sending large amount of data using image transfert.
 * 
 * Based on double & float in order to have the choice to choose you precision
 * 
 * based on Garry Ruddock implementation : https://skytiger.wordpress.com/2010/12/01/packing-depth-into-color/
 * @author bonjour
 */

abstract class GPUImageBaseFloatPacking implements GPUImageInterface, PConstants{
	//Double precision
	private static final double[] DEFACTOR = {1.0, 255.0, 65025.0, 16581375.0};
	private static final double[] DSCALE = {1.0, 256.0, 65536.0};
	private static final double[] DDFACTOR32 = {1.0/1.0, 1.0/255, 1.0/65025.0, 1.0/16581375.0};
	private static final double[] DDFACTOR24 = {DDFACTOR32[0], DDFACTOR32[1], DDFACTOR32[2]};
	private static final double[] DDFACTOR16 = {DDFACTOR32[0], DDFACTOR32[1]};
	private static final double DMASK = 1.0/256.0;
	
	//Float precision
	private static final float[] FEFACTOR = {1.0f, 255.0f, 65025.0f, 16581375.0f};
	private static final float[] FSCALE = {1.0f, 256.0f, 65536.0f};
	private static final float[] FDFACTOR32 = {1.0f/1.0f, 1.0f/255f, 1.0f/65025.0f, 1.0f/16581375.0f};
	private static final float[] FDFACTOR24 = {FDFACTOR32[0], FDFACTOR32[1], FDFACTOR32[2]};
	private static final float[] FDFACTOR16 = {FDFACTOR32[0], FDFACTOR32[1]};
	private static final float FMASK = 1.0f/256.0f;
	
	protected PApplet papplet;
	protected PImage encodedDataImage;
	protected BufferedImage image;
	protected int[] imagePixelData;
	
	
	public GPUImageBaseFloatPacking(PApplet papplet){
		this.papplet = papplet;
	}
	
	protected void paramEncodedDataImage(int dataLength) {
		int[] wh = GPUImage.getWidthHeightFromArea(dataLength);	
		image = new BufferedImage(wh[0], wh[1], BufferedImage.TYPE_INT_ARGB);
		imagePixelData = ((DataBufferInt)image.getRaster().getDataBuffer()).getData();
	}
	
	/** ...............................................
	 * 
	 * 
	 * 		Value encoding to ARGB
	 * 
	 * 
	 ...............................................*/
	
	public int doubleToARGB(double value, int ENCODINGTYPE) {
		/**
		 * Switch case are quite slow. We kept it in order to propose a custom solution but for faster encoding please use direct implementation
		 */
		double[] argb = valueToARGBArray(value, ENCODINGTYPE);
		return GPUImage.getARGB(argb);
	}
	
	public int doubleToARGB32(double value) {
		double[] argb = valueToARGB32(value);
		return GPUImage.getARGB(argb);
	}
	
	public int doubleToARGB24(double value) {
		double[] argb = valueToARGB24(value);
		return GPUImage.getARGB(argb);
	}
	
	public int doubleToARGB16(double value) {
		double[] argb = valueToARGB16(value);
		return GPUImage.getARGB(argb);
	}
	
	public int floatToARGB(float value, int ENCODINGTYPE) {
		/**
		 * Switch case are quite slow. We kept it in order to propose a custom solution but for faster encoding please use direct implementation
		 */
		float[] argb = valueToARGBArray(value, ENCODINGTYPE);
		return GPUImage.getARGB(argb);
	}

	
	public int floatToARGB32(float value) {
		float[] argb = valueToARGB32(value);
		return GPUImage.getARGB(argb);
	}
	
	public int floatToARGB24(float value) {
		float[] argb = valueToARGB24(value);
		return GPUImage.getARGB(argb);
	}
	
	public int floatToARGB16(float value) {
		float[] argb = valueToARGB16(value);
		return GPUImage.getARGB(argb);
	}
	
	public double[] valueToARGBArray(double value, int ENCODINGTYPE) {
		/**
		 * Switch case are quite slow. We kept it in order to propose a custom solution but for faster encoding please use direct implementation
		 */
		switch(ENCODINGTYPE) {
			case ARGB32 : return valueToARGB32(value);
			case ARGB24 : return valueToARGB24(value);
			case ARGB16 : return valueToARGB16(value);
			default : return valueToARGB32(value); 
		}
	}
	
	public float[] valueToARGBArray(float value, int ENCODINGTYPE) {
		/**
		 * Switch case are quite slow. We kept it in order to propose a custom solution but for faster encoding please use direct implementation
		 */
		switch(ENCODINGTYPE) {
			case ARGB32 : return valueToARGB32(value);
			case ARGB24 : return valueToARGB24(value);
			case ARGB16 : return valueToARGB16(value);
			default : return valueToARGB32(value); 
		}
	}
	
	//RGBA
	protected double[] valueToARGB32(double value) {
		double[] rgba = {
				DEFACTOR[0] * value,
				DEFACTOR[1] * value,
				DEFACTOR[2] * value,
				DEFACTOR[3] * value,
		};
			  
		rgba[1] = GPUImage.fract(rgba[1]);
		rgba[2] = GPUImage.fract(rgba[2]);
		rgba[3] = GPUImage.fract(rgba[3]);
			  
		rgba[0] -= rgba[1] * DMASK;
		rgba[1] -= rgba[2] * DMASK;
		rgba[2] -= rgba[3] * DMASK;
		//rgba[3] = 1.0; //avoid 0 as alpha
			  
		//remap between 0 and 255
		rgba[0] *= 255.0;
		rgba[1] *= 255.0;
		rgba[2] *= 255.0;
		rgba[3] *= 255.0;
			  

		return rgba;
	}
	
	protected float[] valueToARGB32(float value) {
		float[] rgba = {
				FEFACTOR[0] * value,
				FEFACTOR[1] * value,
				FEFACTOR[2] * value,
				FEFACTOR[3] * value,
		};
			  
		rgba[1] = GPUImage.fract(rgba[1]);
		rgba[2] = GPUImage.fract(rgba[2]);
		rgba[3] = GPUImage.fract(rgba[3]);
			  
		rgba[0] -= rgba[1] * FMASK;
		rgba[1] -= rgba[2] * FMASK;
		rgba[2] -= rgba[3] * FMASK;
		//rgba[3] = 1.0; //avoid 0 as alpha
			  
		//remap between 0 and 255
		rgba[0] *= 255.0;
		rgba[1] *= 255.0;
		rgba[2] *= 255.0;
		rgba[3] *= 255.0;
			  
		return rgba;
	}
	
	//RGB
	protected double[] valueToARGB24(double value) {
		double[] rgb = {
				DEFACTOR[0] * value,
				DEFACTOR[1] * value,
				DEFACTOR[2] * value
			    };
			  
		rgb[1] = GPUImage.fract(rgb[1]);
		rgb[2] = GPUImage.fract(rgb[2]);
			  
		rgb[0] -= rgb[1] * DMASK;
		rgb[1] -= rgb[2] * DMASK;
			  
		//remap between 0 and 255
		rgb[0] *= 255.0;
		rgb[1] *= 255.0;
		rgb[2] *= 255.0;

		return rgb;
	}
	

	protected float[] valueToARGB24(float value) {
		float[] rgb = {
				FEFACTOR[0] * value,
				FEFACTOR[1] * value,
				FEFACTOR[2] * value
			    };
			  
		rgb[1] = GPUImage.fract(rgb[1]);
		rgb[2] = GPUImage.fract(rgb[2]);
			  
		rgb[0] -= rgb[1] * FMASK;
		rgb[1] -= rgb[2] * FMASK;
			  
		//remap between 0 and 255
		rgb[0] *= 255.0;
		rgb[1] *= 255.0;
		rgb[2] *= 255.0;
			  
		return rgb;
	}
	
	//RG
	protected double[] valueToARGB16(double value) {
		double[] rgb = {
				DEFACTOR[0] * value,
				DEFACTOR[1] * value
			  };
			  
		rgb[1] = GPUImage.fract(rgb[1]);
			  
		rgb[0] -= rgb[1] * DMASK;
			  
		//remap between 0 and 255
		rgb[0] *= 255.0;
		rgb[1] *= 255.0;
			  
		return rgb;
	}

	protected float[] valueToARGB16(float value) {
		float[] rgb = {
				FEFACTOR[0] * value,
				FEFACTOR[1] * value
			  };
			  
		rgb[1] = GPUImage.fract(rgb[1]);
			  
		rgb[0] -= rgb[1] * FMASK;
			  
		//remap between 0 and 255
		rgb[0] *= 255.0;
		rgb[1] *= 255.0;
			  
		return rgb;
	}
	
	/** ...............................................
	 * 
	 * 
	 * 		Value decoding from ARGB
	 * 
	 * 
	 ...............................................*/	
	
	
	public double ARGBToDouble(int argb, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case ARGB32 : return ARGB32ToDouble(argb);
			case ARGB24 : return ARGB24ToDouble(argb);
			case ARGB16 : return ARGB16ToDouble(argb);
			default : return ARGB32ToDouble(argb); 
		}
	}
	
	public float ARGBToFloat(int argb, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case ARGB32 : return ARGB32ToFloat(argb);
			case ARGB24 : return ARGB24ToFloat(argb);
			case ARGB16 : return ARGB16ToFloat(argb);
			default : return ARGB32ToFloat(argb); 
		}
	}
	
	public double ARGB32ToDouble(int argb) {
		double[] rgbaArray = GPUImage.getRGBADouble(argb);
		return GPUImage.dot(rgbaArray, DDFACTOR32) / 255.0;
	}
	
	public float ARGB32ToFloat(int argb) {
		float[] rgbaArray = GPUImage.getRGBAFloat(argb);
		return GPUImage.dot(rgbaArray, FDFACTOR32) / 255.0f;
	}
	
	public double ARGB24ToDouble(int argb) {
		double[] rgbaArray = GPUImage.getRGBADouble(argb);
		return GPUImage.dot(rgbaArray, DDFACTOR24) / 255.0;
	}
	
	public float ARGB24ToFloat(int argb) {
		float[] rgbaArray = GPUImage.getRGBAFloat(argb);
		return GPUImage.dot(rgbaArray, FDFACTOR24) / 255.0f;
	}
	
	public double ARGB16ToDouble(int argb) {
		double[] rgbaArray = GPUImage.getRGBADouble(argb);
		return GPUImage.dot(rgbaArray, DDFACTOR16) / 255.0;
	}
	
	public float ARGB16ToFloat(int argb) {
		float[] rgbaArray = GPUImage.getRGBAFloat(argb);
		return GPUImage.dot(rgbaArray, FDFACTOR16) / 255.0f;
	}
	
}