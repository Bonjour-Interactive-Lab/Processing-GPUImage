package gpuimage.utils;

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

public class GPUImageBaseFloatPacking implements GPUImageInterface, PConstants{
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
	
	
	public GPUImageBaseFloatPacking(){
		
	}
	
	/** ...............................................
	 * 
	 * 
	 * 		Value encoding to ARGB
	 * 
	 * 
	 ...............................................*/
	
	
	public int valueToARGB(double value, int ENCODINGTYPE) {
		double[] argb = valueToARGBArray(value, ENCODINGTYPE);
		return GPUImage.getARGB(argb);
	}
	
	public int valueToARGB(float value, int ENCODINGTYPE) {
		float[] argb = valueToARGBArray(value, ENCODINGTYPE);
		return GPUImage.getARGB(argb);
	}
	
	public double[] valueToARGBArray(double value, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case ARGB32 : return valueToARGB32(value);
			case ARGB24 : return valueToARGB24(value);
			case ARGB16 : return valueToARGB16(value);
			default : return valueToARGB32(value); 
		}
	}
	
	public float[] valueToARGBArray(float value, int ENCODINGTYPE) {
		switch(ENCODINGTYPE) {
			case ARGB32 : return valueToARGB32(value);
			case ARGB24 : return valueToARGB24(value);
			case ARGB16 : return valueToARGB16(value);
			default : return valueToARGB32(value); 
		}
	}
	
	//RGBA
	private double[] valueToARGB32(double value) {
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
	
	private float[] valueToARGB32(float value) {
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
	private double[] valueToARGB24(double value) {
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
	

	private float[] valueToARGB24(float value) {
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
	private double[] valueToARGB16(double value) {
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

	private float[] valueToARGB16(float value) {
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
	
	private double ARGB32ToDouble(int argb) {
		double[] rgbaArray = GPUImage.getRGBADouble(argb);
		return GPUImage.dot(rgbaArray, DDFACTOR32) / 255.0;
	}
	
	private float ARGB32ToFloat(int argb) {
		float[] rgbaArray = GPUImage.getRGBAFloat(argb);
		return GPUImage.dot(rgbaArray, FDFACTOR32) / 255.0f;
	}
	
	private double ARGB24ToDouble(int argb) {
		double[] rgbaArray = GPUImage.getRGBADouble(argb);
		return GPUImage.dot(rgbaArray, DDFACTOR24) / 255.0;
	}
	
	private float ARGB24ToFloat(int argb) {
		float[] rgbaArray = GPUImage.getRGBAFloat(argb);
		return GPUImage.dot(rgbaArray, FDFACTOR24) / 255.0f;
	}
	
	private double ARGB16ToDouble(int argb) {
		double[] rgbaArray = GPUImage.getRGBADouble(argb);
		return GPUImage.dot(rgbaArray, DDFACTOR16) / 255.0;
	}
	
	private float ARGB16ToFloat(int argb) {
		float[] rgbaArray = GPUImage.getRGBAFloat(argb);
		return GPUImage.dot(rgbaArray, FDFACTOR16) / 255.0f;
	}
	
}