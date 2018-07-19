package gpuimage.utils;

import gpuimage.core.GPUImageInterface;

/**
 * Various methods and helper for pixel computation and color getter
 * @author bonjour
 */
public abstract class GPUImageMathsPixels implements GPUImageInterface{
	//Image helpers
	/**
	 * Get a width and height of an rectangle/image by a given area. Returned as int{width, height};
	 * @param area
	 * @return
	 */
	public static int[] getWidthHeightFromArea(int area) {
		//NB maybe we can throw an exception if area is prime because it will only retur a texture of 1 × area
		
		float sqrtArea = (float)Math.sqrt(area);
		int isqrtArea = (int)Math.ceil(sqrtArea);
		  
		int w = 0;
		int h = 0;
		for (h=isqrtArea; h>0; h--) {
			// integer division discarding remainder:
			w = area/h;
			if ( w*h == area ) {
				// closest pair is (w,h)
				break;
			}
		}
	
		int[] wh = {w, h};
		return wh;
	}
	
	//Maths inpired by GLSL method
	/**
	 * Compute the fractional part of the argument as double
	 * @param value
	 * @return
	 */
	public static double fract(double value) {
		return value % 1.0;
	}
	
	/**
	 * Compute the fractional part of the argument as float
	 * @param value
	 * @return
	 */
	public static float fract(float value) {
		return value % 1.0f;
	}
	
	/**
	 * Compute the dot product between two vector described as arrays. Returned value as double.
	 * @param A
	 * @param B
	 * @return
	 */
	public static double dot(double[] A, double[] B) {
		//need to throw exception iof the two array has not the same length
		double sum = 0.0;
		for(int i=0; i<A.length && i<B.length; i++) {
			double compMult = A[i] * B[i];
			sum += compMult;
		}
		return sum;
	}
	
	/**
	 * Compute the dot product between two vector described as arrays. Returned value as float.
	 * @param A
	 * @param B
	 * @return
	 */
	public static float dot(float[] A, float[] B) {
		//need to throw exception iof the two array has not the same length
		float sum = 0.0f;
		for(int i=0; i<A.length && i<B.length; i++) {
			float compMult = A[i] * B[i];
			sum += compMult;
		}
		return sum;
	}
	
	//Pixels
	/**
	 * Return an array of RGBA component as double
	 * @param argb
	 * @return
	 */
	public static double[] getRGBADouble(int argb) {
		double a = argb >> 24 & 0xFF;
		double r = argb >> 16 & 0xFF;
		double g = argb >> 8 & 0xFF;
		double b = argb & 0xFF;
		double[] rgbaArray = {r, g, b, a};
		return rgbaArray;
	}
	
	/**
	 * Return an array of RGBA component as float
	 * @param argb
	 * @return
	 */
	public static float[] getRGBAFloat(int argb) {
		float a = argb >> 24 & 0xFF;
		float r = argb >> 16 & 0xFF;
		float g = argb >> 8 & 0xFF;
		float b = argb & 0xFF;
		float[] rgbaArray = {r, g, b, a};
		return rgbaArray;
	}
	
	/**
	 * Return the int value of a RGBA double array
	 * @param rgba
	 * @return
	 */
	public static int getARGB(double[] rgba) {
		double[] frgba = {255.0, 255.0, 255.0, 255.0};
		
		for(int i=0; i<rgba.length; i++) {
			frgba[i] = rgba[i];
		}
		
		if (frgba[3] > 255) frgba[3] = 255; else if (frgba[3] < 0) frgba[3] = 0;
		if (frgba[0] > 255) frgba[0] = 255; else if (frgba[0] < 0) frgba[0] = 0;
		if (frgba[1] > 255) frgba[1] = 255; else if (frgba[1] < 0) frgba[1] = 0;
		if (frgba[2] > 255) frgba[2] = 255; else if (frgba[2] < 0) frgba[2] = 0;
			  
		return (int)frgba[3] << 24 | (int)frgba[0] << 16 | (int)frgba[1] << 8 |(int)frgba[2];
	}
	
	/**
	 * Return the int value of a RGBA double float
	 * @param rgba
	 * @return
	 */
	public static int getARGB(float[] rgba) {
		float[] frgba = {255.0f, 255.0f, 255.0f, 255.0f};
		
		for(int i=0; i<rgba.length; i++) {
			frgba[i] = rgba[i];
		}
		
		if (frgba[3] > 255) frgba[3] = 255; else if (frgba[3] < 0) frgba[3] = 0;
		if (frgba[0] > 255) frgba[0] = 255; else if (frgba[0] < 0) frgba[0] = 0;
		if (frgba[1] > 255) frgba[1] = 255; else if (frgba[1] < 0) frgba[1] = 0;
		if (frgba[2] > 255) frgba[2] = 255; else if (frgba[2] < 0) frgba[2] = 0;
			  
		return (int)frgba[3] << 24 | (int)frgba[0] << 16 | (int)frgba[1] << 8 |(int)frgba[2];
	}
}