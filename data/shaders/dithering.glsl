/**
 * Based on : 
 * * Alex Charlton implementation : http://alex-charlton.com/posts/Dithering_on_the_GPU/#fn1
 * * Bayer Matrix : https://en.wikipedia.org/wiki/Ordered_dithering
 * * http://caca.zoy.org/study/part2.html
 *
 * Update by Bonjour Lab
 */
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

const int bayer2x2[4] = int[](0, 2,
							  3, 1);

const int bayer3x3[9] = int[](0, 7, 3,
							  6, 5, 2,
							  4, 1, 8);

const int bayer4x4[16] = int[](0,  8,  2, 10,
							  12,  4, 14,  6,
							   3, 11,  1,  9,
							  15,  7, 13,  5);

const int bayer8x8[64] = int[](0,  32, 8,  40, 2,  34, 10, 42,
                              48, 16, 56, 24, 50, 18, 58, 26,
                              12, 44, 4,  36, 14, 46, 6,  38,
                              60, 28, 52, 20, 62, 30, 54, 22,
                              3,  35, 11, 43, 1,  33, 9,  41,
                              51, 19, 59, 27, 49, 17, 57, 25,
                              15, 47, 7,  39, 13, 45, 5,  37,
                              63, 31, 55, 23, 61, 29, 53, 21);

const int clusterDot4x4[16] = int[](12,  5,  6, 13,
								  	 4,  0,  1,  7,
								   	11,  3,  2,  8,
								  	15, 10,  9, 14); 


const int clusterDot8x8[64] = int[](24, 10, 12, 26, 35, 47, 49, 37,
									 8,  0,  2, 14, 45, 59, 61, 51,
									22,  6,  4, 16, 43, 57, 63, 53,
									30, 20, 18, 28, 33, 41, 55, 39,
									34, 46, 48, 36, 25, 11, 13, 27,
									44, 58, 60, 50,  9,  1,  3, 15,
									42, 56, 62, 52, 23,  7,  5, 17,
									32, 42, 54, 38, 31, 21, 19, 29);

const int clusterDot5x3[15] = int[]( 9,  3,  0,  6, 12,
									10,  4,  1,  7, 13,
									11,  5,  2,  8, 14);

const int random3x3[54] = int[](1, 4, 7,
							    6, 0, 2,
							    3, 8, 5,
							    4, 6, 3,
							    8, 1, 5,
							    0, 3, 7,
							    5, 0, 3,
							    2, 8, 6,
							    7, 4, 1,
							    8, 2, 5,
							    6, 4, 0,
							    1, 7, 3,
							    2, 5, 8,
							    0, 7, 3,
							    4, 1, 6,
							    7, 4, 1,
							    3, 6, 8,
							    2, 0, 5);

uniform sampler2D texture;
uniform vec2 resolution;
uniform float theta;

in vec4 vertTexCoord;
out vec4 fragColor;

mat2 rotate2D(float angle){
	return mat2( cos(angle), -sin(angle),
				 sin(angle),  cos(angle));
}

float random(vec2 tex){
	//return fract(sin(x) * offset);
	return fract(sin(dot(tex.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

float index(vec2 screenpos){
	int x  = int(mod(screenpos.x, 8));
	int y  = int(mod(screenpos.y, 8));
	//int rand = (9 * int(floor(random(vertTexCoord.xy) * 6))) / 4;
	return (1.0 + clusterDot8x8[(x + y * 8)]) / (64.0 + 1.0);
}

float dither(vec2 screenpos, float lum){
	float closestOne = step(0.5, lum);
	float closestTwo = 1.0 - closestOne;
	float d = index(screenpos);
	float distance = abs(closestOne - lum);
	float ifdist = step(d, distance);
	float elsedist = 1.0 - step(d, distance);
	return closestOne * elsedist + closestTwo * ifdist;
}


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);
	float luma = getLuma(tex.rgb);

	//rotate uv
	uv -= vec2(0.5, 0.5);
    uv = rotate2D(theta) * uv;
    uv += vec2(0.5, 0.5);
    
	float value = dither(uv * resolution, luma);
	float red = dither(uv * resolution, tex.r);
	float green = dither(uv * resolution, tex.g);
	float blue = dither(uv * resolution, tex.b);

	fragColor = vec4(red, green, blue, 1.0);
}