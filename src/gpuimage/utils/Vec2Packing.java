package gpuimage.utils;
import java.awt.image.BufferedImage;


import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import gpuimage.core.GPUImage;
import gpuimage.core.GPUImageInterface;
import processing.core.*;

/**
 * Vec2Packing is an utils class allowing to packing Vector2 (PVector) into RGBA texture.<br>
 * This technic is usefull when you need to pass and array of values from CPU to GPU for vairous GPGPU computation on shader side — 
 * such as physics simulation on pixel analysis like optical flow — or if you need to send large amount of data as texture (using spout, syphon or NDI)<br>
 * 
 * <p>
 * The main idea is to take each component of the vector on a range 0-1 and split/encode it into 16 bits as color where :<br>
 * <ul>
 * <li><b>vector.x</b> : the value is encoded into Red and Green (8 bits per channel). <b>255 * 255</b></li>
 * <li><b>vector.y</b> : the value is encoded into Blue and Alpha (8 bits per channel). <b>255 * 255</b></li>
 * </ul>
 * <p>
 *  * <p><b>All color are send as int.</b> You can use it with the processing variable color</p>
 * <p> the value can be retreived on CPU side via the provided methods or en GPU (shader) side via the following methods :
 * <pre>
 * {@code
 * 
 * 
 * }
 * </pre>
 * 
 * @see FloatPacking
 * @see GPUImageInterface
 * @author bonjour
 *
 */
public class Vec2Packing extends GPUImageBaseFloatPacking{

	
	public Vec2Packing(PApplet papplet){
		super(papplet);
	}
	
	/**
	 * Encode PVector array into RGBA texture
	 * @param data
	 * @return
	 */
	public PImage encodeARGB(PVector[] data) {
		this.paramEncodedDataImage(data.length);
		this.encodeARGB16(data);
		encodedDataImage = new PImage(image);
		encodedDataImage.parent = this.papplet;
		return encodedDataImage;
	}
	
	//encode PVector component into RGBA16
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
	
	/**
	 * Decode RGBA texture into PVector array
	 * @param img
	 * @return
	 */
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
	
	//prepare PVector datas
	private PVector[] setVectorArray(PImage img) {
		img.loadPixels();
		PVector[] datas = new PVector[img.pixels.length];
		return datas;
	}
	
}