package gpuimage.core;

import gpuimage.utils.GPUImageMathsPixels;
import processing.core.*;
import processing.opengl.PGraphicsOpenGL;

/**
 * GPUImage is the main class of the GPUImage library.
 * It's provide context information such as GPU Vendor or OPENGL version
 * @author bonjour
 *
 */
public class GPUImage extends GPUImageMathsPixels implements GPUImageInterface, PConstants{
	//Static class
	/**
	 * Static class feed with the library informations
	 */
	static public class GPUImageInfos{
		public static final String DESCRIPTION = "##library.sentence##";
		public static final String VERSION     = "##library.prettyVersion##";
		public static final String NAME        = "##library.name##";
		public static final String AUTHOR      = "##author.name##";
		public static final String WEB         = "##author.url##";
		//this will be enable after the public release
		//public static final String GIT         = "##source.repository##";
		
		/**
		 * Return Name, version and authors as String
		 * @return
		 */
		public String getLibraryInfos(){
			return NAME +" "+ VERSION+" by "+AUTHOR;
		}
	}

	/**
	 * GPU and OPENGL informations
	 */
	static public class GPUInfos{
		private static String VENDOR;
		private static String RENDERER;
		private static String GLVERSION;
		private static String GLSLVERSION;
		//private static String GLEXTENSION;
		
		public GPUInfos() {
			VENDOR             = PGraphicsOpenGL.OPENGL_VENDOR;
			RENDERER           = PGraphicsOpenGL.OPENGL_RENDERER;
			GLVERSION          = PGraphicsOpenGL.OPENGL_VERSION;
			GLSLVERSION        = PGraphicsOpenGL.GLSL_VERSION;
		}
		
		/**
		 * Return Renderer, vendor, GLVersion, GLSLVersion as String
		 * @return
		 */
		public String getGpuInfos() {
			return "GPU : "    +RENDERER    +" by "+VENDOR+"\n"+
					"OpenGL : "+GLVERSION   +"\n"+
					"GLSL : "  +GLSLVERSION;
		}
	}

	//variables
	static public final GPUImageInfos LIBINFO;
	static public final GPUInfos      GPUINFO;
	public PApplet papplet;
	
	//constructor
	static {
		LIBINFO = new GPUImageInfos();
		GPUINFO = new GPUInfos();
	}
	
	/**
	 * Simple constructor
	 * @param papplet
	 */
	public GPUImage(PApplet papplet){
		this.papplet = papplet;
		this.papplet.registerMethod("dispose", this);
	}

	//methods
	/**
	 * print the informations of the library
	 */
	public static void printInfos(){
		System.out.println(LIBINFO.getLibraryInfos());
		System.out.println();
	}
	
	/**
	 * print the GPU informations
	 */
	public static void printGLInfos() {
		System.out.println(GPUINFO.getGpuInfos());
		System.out.println();
	}
	
	public void dispose() {
	    // Anything in here will be called automatically when 
	    // the parent sketch shuts down. For instance, this might
	    // shut down a thread used by this library.
	  }
}