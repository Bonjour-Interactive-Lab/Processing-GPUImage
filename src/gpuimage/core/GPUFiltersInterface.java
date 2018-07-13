package gpuimage.core;

public interface GPUFiltersInterface{
	//Level
	public static final String LOW = "low";
	public static final String MED = "medium";
	public static final String HIGH = "high";
	public static final String HIGH2 = "high2";
	
	//shader names
	public static final String UV = "uv";
	
	//Filtering
	public static final String BILATERAL = "bilateral";
	public static final String BICUBIC = "bicubic";
	public static final String DENOISE = "denoise";
	public static final String MEDIAN3X3 = "median3x3";
	public static final String MEDIAN5X5 = "median5x5";
	public static final String SOBEL = "sobel";
	
	public static final String GAUSSIANBLUR = "gaussianblur";
	public static final String GAUSSIANBLUR5X5 = "gaussianblur5x5";
	public static final String GAUSSIANBLUR7X7 = "gaussianblur7x7";
	public static final String GAUSSIANBLUR9X9 = "gaussianblur9x9";
	public static final String GAUSSIANBLUR13X13 = "gaussianblur13x13";
	public static final String RADIALBLUR = "radialblur";
	
	public static final String CONTRASTSATBRIGHT = "constrastsaturationbrightness";
	public static final String DESATURATE = "desaturate";
	public static final String LEVEL = "level";
	public static final String GAMMA = "gamma";
	public static final String LUT = "lut";
	public static final String HIGHPASS = "highpass";
	public static final String THRESHOLD = "threshold";
	
	public static final String CHROMAWARP = "chromawarp";
	public static final String CHROMAWARPLOW = "chromawarplow";
	public static final String CHROMAWARPMED = "chromawarpmedium";
	public static final String CHROMAWARPHIGH = "chromawarphigh";
	public static final String GRAIN = "grain";
	public static final String PIXELATE = "pixelate";
	public static final String ASCII = "ascii";
	public static final String BLOOM = "bloom";
	public static final String DOUBLEEXPOSURE = "doubleexposure";
	
	public static final String MASK = "mask";
	public static final String DILATE = "dilate";
	public static final String ERODE = "erode";
	public static final String PIXELSORTING ="pixelsorting";
	public static final String DOF = "dof";
	public static final String ALPHASPRITE = "alphasprite";
	
	public static final String OPTICALFLOW = "opticalflow";
	
}