#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PI 3.14159265359
uniform sampler2D texture;
uniform vec2 dir = vec2(0.0, 1.0);
//uniform float radius = 2.0;
//uniform vec2 resolution;


uniform float blurSize = 1.0; // This should usually be equal to
                         // 1.0f / texture_pixel_width for a horizontal blur, and
                         // 1.0f / texture_pixel_height for a vertical blur.
uniform float sigma = 4.0; //The sigma value for the gaussian function: higher value means more blur

in vec4 vertTexCoord;
out vec4 fragColor;

#define avgPos(i) 	avgValue += texture(texture, uv - i * blurSize * dir) * incrementalGaussian.x;
#define avgNeg(i) 	avgValue += texture(texture, uv + i * blurSize * dir) * incrementalGaussian.x; 
#define coeff()	  	coefficientSum += 2.0 * incrementalGaussian.x;
#define incGauss()	incrementalGaussian.xy *= incrementalGaussian.yz;
#define blur(i)		avgPos(i); avgNeg(i); coeff(); incGauss();
#define blur5x5()	blur(1); blur(2);
#define blur7x7()	blur5x5(); blur(3);
#define blur9x9()	blur7x7(); blur(4);
#define blur13x13()	blur9x9(); blur(5); blur(6); blur(7);

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
  	avgValue += texture(texture, uv) * incrementalGaussian.x;
  	coefficientSum += incrementalGaussian.x;
  	incrementalGaussian.xy *= incrementalGaussian.yz;

  	blur9x9();

  	fragColor = avgValue / coefficientSum;
}