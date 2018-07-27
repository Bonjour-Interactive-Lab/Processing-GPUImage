package gpuimage.utils;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;


/**
 * IntPacking is an utils class allowing to packing integer value into RGBA texture using modulo 255 for Red/Green value and Blue channel for column index per modulo.<br>
 * This technic is usefull when you need to pass and integer array of values from CPU to GPU for vairous GPGPU computation on shader side — 
 * such as physics simulation on pixel analysis like optical flow — or if you need to send large amount of data as texture (using spout, syphon or NDI)<br>
 * This class provide a faster encoding/decoding methods than the FloatPacking by using only modulo and alpha channel.
 * <b>Howerver this cannot be use for non integer value.</b>
 * 
 * <p>
 * The main idea is to take a integer value from a range of 0 to <b>KNOWN</b> value and split it across a the RG channel by using a value%255.<br>
 * The index of the modulo (number of repetition across the range) is store into the blue channel<br>

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
*uniform sampler2D texture;
*uniform int dataMax;
*
*in vec4 vertTexCoord;
*out vec4 fragColor;
*
*
*vec4 encodeRGBAMod(float value, float edge){
*	float divider = float(edge) / 256.0;
*
*	float modValue = mod(value, 255.0);
*	float modIndex = value / 255.0;
*
*	float index = modIndex / divider;
*	float luma = fract(modValue);
*
*	return vec4(luma, luma, index, 1.0);
*}
*
*float decodeRGBAMod(vec4 rgba, float edge){
*	float divider = float(edge) / 256.0;
*	float index = round(rgba.b * divider);
*
*	return rgba.r * 255.0 + 255.0 * index;
*}
*
*void main(){
*	vec2 uv = vertTexCoord.xy;
*	vec4 tex = texture2D(texture, uv);
*
*	float data = decodeRGBAMod(tex, dataMax);
*	vec4 encodedData = encodeRGBAMod(data, float(dataMax));
*
*	fragColor = encodedData;
*}
 * }
 * </pre>
 * @author bonjour
 * @see GPUImageInterface
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
	
	/**
	 * Defines the size of the output encoded texture and prepares the PImage
	 * @param dataLength
	 */
	private void paramEncodedDataImage(int dataLength) {
		int[] wh = GPUImage.getWidthHeightFromArea(dataLength);	
		image = new BufferedImage(wh[0], wh[1], BufferedImage.TYPE_INT_ARGB);
		imagePixelData = ((DataBufferInt)image.getRaster().getDataBuffer()).getData();
	}
	
	/**
	 * Encode int array into RGBA texture
	 * @param datas
	 * @param maxDataValue Maximum value known into the datas array
	 * @return
	 */
	public PImage encodeARGB(int[] datas, int maxDataValue) {
		paramEncodedDataImage(datas.length);
		divider = maxDataValue / 256.0f;
		encodeARGBMod(datas);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	//encode int to RGBA % 255
	private void encodeARGBMod(int[] datas) {
		for(int i=0; i<datas.length; i++){
			int value = datas[i];
			int modValue = value % 255;
			int modIndex = value / 255;
			int modIndexBlue= Math.round(((float)modIndex / divider) * 255);
			imagePixelData[i] = (255 << 24) | (modValue << 16) | (modValue << 8) | modIndexBlue;
		}
	}
	
	/**
	 * Decode RGBA texture into int array
	 * @param img
	 * @param maxDataValue Maximum value known into the datas array
	 * @return
	 */
	public int[] decodeARGB(PImage img, int maxDataValue) {
		img.loadPixels();
		float divider = maxDataValue / 256.0f;
		int[] datas = new int[img.width * img.height];
		for(int i=0; i<datas.length; i++) {
			int b = img.pixels[i] & 0xFF;
			int r = img.pixels[i] >> 16 & 0xFF;
			
			int modIndexRetreived = Math.round((b / 255.0f) * divider);
			datas[i] = (r + 255 * modIndexRetreived);
		}
		
		return datas;
	}
	
	
	private float getLastDivider() {
		return this.divider;
	}
	
}