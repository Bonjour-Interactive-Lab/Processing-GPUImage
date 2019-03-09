package gpuimage.core;

/**
 * Names shared throughout the gpuimage.core
 * @author bonjour
 *
 */
public interface GPUImageInterface{
	
	/**
	 * Quality setting. By default the quality of filtering is set as LOW.
	 * For filtering the quality define the used of optmized shader, the higher is the quality the sahding compution is heavy
	 */
	public static final String LOW = "low";
	/**
	 * Quality setting.
	 * @see #LOW
	 */
	public static final String MED = "medium";
	/**
	 * Quality setting.
	 * @see #LOW
	 */
	public static final String HIGH = "high";
	/**
	 * Quality setting.
	 * @see #LOW
	 */
	public static final String HIGH2 = "high2";
	

	/* ...............................................
	 * 
	 * 
	 * 					FILTERING 
	 * 
	 * 
	 ...............................................*/
	
	public static final String UV = "uv";
	public static final String BILATERAL = "bilateral";
	public static final String DENOISE = "denoise";
	public static final String MEDIAN3X3 = "median3x3";
	public static final String MEDIAN5X5 = "median5x5";
	public static final String HIGHPASS = "highpass";
	public static final String SOBEL = "sobel";
	public static final String SOBELEDGE = "sobeledge";
	public static final String CANNYEDGE = "cannyedge1";
	public static final String HUESEGMENTATION = "huesegmentation";
	public static final String SIGNEDDISTANCEFIELD = "signeddistancefield";
	
	public static final String GAUSSIANBLUR = "gaussianblur";
	public static final String GAUSSIANBLUR5X5 = "gaussianblur5x5";
	public static final String GAUSSIANBLUR7X7 = "gaussianblur7x7";
	public static final String GAUSSIANBLUR9X9 = "gaussianblur9x9";
	public static final String GAUSSIANBLUR13X13 = "gaussianblur13x13";
	public static final String RADIALBLUR = "radialblur";
	public static final String RADIALBLURLOW = "radialblurlow";
	public static final String RADIALBLURMED = "radialblurmedium";
	public static final String RADIALBLURLHIGH = "radialblurhigh";
	
	public static final String CONTRASTSATBRIGHT = "constrastsaturationbrightness";
	public static final String DESATURATE = "desaturate";
	public static final String LEVEL = "level";
	public static final String GAMMA = "gamma";
	public static final String LUT1D = "lut1d";
	public static final String LUT1DGEN = "lut1dgen";
	public static final String LUT2DGEN = "lut2dgen";
	public static final String RAMP1D = "ramp1d";
	public static final String COLORTHRESHOLD = "colorthreshold";
	public static final String THRESHOLD = "threshold";
	public static final String INVERT = "invert";
	
	public static final String CHROMAWARP = "chromawarp";
	public static final String CHROMAWARPLOW = "chromawarplow";
	public static final String CHROMAWARPMED = "chromawarpmedium";
	public static final String CHROMAWARPHIGH = "chromawarphigh";
	public static final String GRAIN = "grain";
	public static final String GRAINRGB = "grainrgb";
	public static final String PIXELATE = "pixelate";

	public static final String DITHERBAYER2X2 = "ditheringbayer2x2";
	public static final String DITHERBAYER2X2RGB = "ditheringbayer2x2rgb";
	public static final String DITHERBAYER3X3 = "ditheringbayer3x3";
	public static final String DITHERBAYER3X3RGB = "ditheringbayer3x3rgb";
	public static final String DITHERBAYER4X4 = "ditheringbayer4x4";
	public static final String DITHERBAYER4X4RGB = "ditheringbayer4x4rgb";
	public static final String DITHERBAYER8X8 = "ditheringbayer8x8";
	public static final String DITHERBAYER8X8RGB = "ditheringbayer8x8rgb";
	public static final String DITHERCLUSTERDOT4X4 = "ditheringclusterdot4x4";
	public static final String DITHERCLUSTERDOT4X4RGB = "ditheringclusterdot4x4rgb";
	public static final String DITHERCLUSTERDOT8X8 = "ditheringclusterdot8x8";
	public static final String DITHERCLUSTERDOT8X8RGB = "ditheringclusterdot8x8rgb";
	public static final String DITHERCLUSTERDOT5X3 = "ditheringclusterdot5x3";
	public static final String DITHERCLUSTERDOT5X3RGB = "ditheringclusterdot5x3rgb";
	public static final String DITHERRANDOM3X3 = "ditheringrandom3x3";
	public static final String DITHERRANDOM3X3RGB = "ditheringrandom3x3rgb";
	
	public static final String DILATE = "dilation";
	public static final String ERODE = "erosion";
	public static final String DILATERGB = "dilationrgb";
	public static final String ERODERGB = "erosionrgb";
	
	public static final String GLITCHDISPLACELUMA = "glitchdisplaceluma";
	public static final String GLITCHDISPLACERGB = "glitchdisplacergb";
	public static final String GLITCHINVERT = "glitchinvert";
	public static final String GLITCHPIXELATE = "glitchpixelate";
	public static final String GLITCHSHIFTRGB = "glitchshiftrgb";
	public static final String GLITCHSHUFFLERGB = "glitchshufflergb";
	public static final String GLITCHSTITCH = "glitchstitch";

	/* ...............................................
	 * 
	 * 
	 * 					COMPOSITING 
	 * 
	 * 
	 ...............................................*/
	
	public static final String MASK = "mask";
	public static final String MASK2 = "mask2";
	public static final String CHROMAKEY = "chromakey";
	public static final String CHROMAKEY2 = "chromakey2";
	public static final String ALPHASPRITE = "alphasprite";
	
	public static final String ADD = "blendadd";
	public static final String AVERAGE = "blendaverage";
	public static final String COLOR = "blendcolor";
	public static final String COLORBURN = "blendcolorburn";
	public static final String COLORDODGE = "blendcolordodge";
	public static final String DARKEN = "blenddarken";
	public static final String DIFFERENCE = "blenddifference";
	public static final String EXCLUSION = "blendexclusion";
	public static final String GLOW = "blendglow";
	public static final String HARDLIGHT = "blendhardlight";
	public static final String HARDMIX = "blendhardmix";
	public static final String HUE = "blendhue";
	public static final String LIGHTEN = "blendlighten";
	public static final String LINEARBURN = "blendlinearburn";
	public static final String LINEARDODGE = "blendlineardodge";
	public static final String LINEARLIGHT = "blendlinearlight";
	public static final String LUMINOSITY = "blendluminosity";
	public static final String MULTIPLY = "blendmultiply";
	public static final String NEGATION = "blendnegation";
	public static final String OVERLAY = "blendoverlay";
	public static final String PHOENIX = "blendphoenix";
	public static final String PINLIGHT = "blendpinlight";
	public static final String REFLECT = "blendreflect";
	public static final String SATURATION = "blendsaturation";
	public static final String SCREEN = "blendscreen";
	public static final String SOFTLIGHT = "blendsoftlight";
	public static final String SUBSTRACT = "blendsubstract";
	public static final String VIVIDLIGHT = "blendvividlight";
	

	/* ...............................................
	 * 
	 * 
	 * 			RGBA ENCODING DECODING 
	 * 
	 * 
	 ...............................................*/
	public static final int ARGB32 = 32;
	public static final int ARGB24 = 24;
	public static final int ARGB16 = 16;
	
	

	/* ...............................................
	 * 
	 * 
	 * 			TEXTURE FILTERING MODE 
	 * 
	 * 
	 ...............................................*/
	public static final int NEAREST 	= 2; 
	public static final int LINEAR 		= 3;
	public static final int BILINEAR 	= 4;
	public static final int TRILINEAR 	= 5;
	
}