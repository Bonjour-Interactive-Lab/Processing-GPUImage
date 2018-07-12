#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PI 3.14159265359
uniform sampler2D texture;
uniform vec2 dir = vec2(0.0, 1.0);
uniform float radius = 2.0;
//uniform vec2 resolution;

/**
 * Based on Gene Kogan and http://callumhay.blogspot.com/2010/09/gaussian-blur-shader-glsl.html
 * Update by Bonjour Lab
 */


uniform float blurSize = 1.0; // This should usually be equal to
                         // 1.0f / texture_pixel_width for a horizontal blur, and
                         // 1.0f / texture_pixel_height for a vertical blur.
uniform float sigma = 4.0; //The sigma value for the gaussian function: higher value means more blur

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	
	vec2 uv = vertTexCoord.xy;
	// Incremental Gaussian Coefficent Calculation (See GPU Gems 3 pp. 877 - 889)

	vec3 incrementalGaussian;
	incrementalGaussian.x = 1.0 / (sqrt(2.0 * PI) * sigma);
	incrementalGaussian.y = exp(-0.5 / (sigma * sigma));
	incrementalGaussian.z = incrementalGaussian.y * incrementalGaussian.y;

 	vec4 avgValue = vec4(0.0, 0.0, 0.0, 0.0);
 	float coefficientSum = 0.0;

  	// Take the central sample first...
  	avgValue += texture2D(texture, uv) * incrementalGaussian.x;
  	coefficientSum += incrementalGaussian.x;
  	incrementalGaussian.xy *= incrementalGaussian.yz;

  	// Go through the remaining 8 vertical samples (4 on each side of the center)
  	for (float i = 1.0; i <= radius; i++) { 
  	  avgValue += texture2D(texture, uv - i * blurSize * dir) * incrementalGaussian.x;         
  	  avgValue += texture2D(texture, uv + i * blurSize * dir) * incrementalGaussian.x;         
  	  coefficientSum += 2.0 * incrementalGaussian.x;
  	  incrementalGaussian.xy *= incrementalGaussian.yz;
  	}

  	fragColor = avgValue / coefficientSum;

	/*
	Matt DesLaurier implementation : https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5
	 */
	/*
	vec4 sum = vec4(0.0);
	vec2 uv = vertTexCoord.xy;

	float hblur = radius / resolution.x;
	float vblur = radius / resolution.y;

	float hstep = dir.x;
	float vstep = dir.y;

	sum += texture2D(texture, vec2(uv.x - 4.0*hblur*hstep, uv.y - 4.0*vblur*vstep)) * 0.0162162162;
	sum += texture2D(texture, vec2(uv.x - 3.0*hblur*hstep, uv.y - 3.0*vblur*vstep)) * 0.0540540541;
	sum += texture2D(texture, vec2(uv.x - 2.0*hblur*hstep, uv.y - 2.0*vblur*vstep)) * 0.1216216216;
	sum += texture2D(texture, vec2(uv.x - 1.0*hblur*hstep, uv.y - 1.0*vblur*vstep)) * 0.1945945946;
	
	sum += texture2D(texture, vec2(uv.x, uv.y)) * 0.2270270270;
	
	sum += texture2D(texture, vec2(uv.x + 1.0*hblur*hstep, uv.y + 1.0*vblur*vstep)) * 0.1945945946;
	sum += texture2D(texture, vec2(uv.x + 2.0*hblur*hstep, uv.y + 2.0*vblur*vstep)) * 0.1216216216;
	sum += texture2D(texture, vec2(uv.x + 3.0*hblur*hstep, uv.y + 3.0*vblur*vstep)) * 0.0540540541;
	sum += texture2D(texture, vec2(uv.x + 4.0*hblur*hstep, uv.y + 4.0*vblur*vstep)) * 0.0162162162;

	fragColor = vec4(sum.rgb, 1.0);
	*/
}