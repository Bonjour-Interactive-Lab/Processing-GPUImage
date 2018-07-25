/**
 * Based on : 
 * * Alex Charlton implementation : http://alex-charlton.com/posts/Dithering_on_the_GPU/#fn1
 * * Bayer Matrix : https://en.wikipedia.org/wiki/Ordered_dithering
 * * http://caca.zoy.org/study/part2.html
 *
 * Update by Bonjour Lab
 */

#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

const int clusterDot8x8[64] = int[](24, 10, 12, 26, 35, 47, 49, 37,
									 8,  0,  2, 14, 45, 59, 61, 51,
									22,  6,  4, 16, 43, 57, 63, 53,
									30, 20, 18, 28, 33, 41, 55, 39,
									34, 46, 48, 36, 25, 11, 13, 27,
									44, 58, 60, 50,  9,  1,  3, 15,
									42, 56, 62, 52, 23,  7,  5, 17,
									32, 42, 54, 38, 31, 21, 19, 29);


uniform sampler2D texture;
uniform vec2 resolution;

in vec4 vertTexCoord;
out vec4 fragColor;

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

float index(vec2 screenpos){
	int x  = int(mod(screenpos.x, 8));
	int y  = int(mod(screenpos.y, 8));
	return (1.0 + clusterDot8x8[(x + y * 8)]) / (64.0 + 1.0);
}

float dither(vec2 screenpos, float lum){
	float d = index(screenpos);
	return step(d, lum);
}


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);
	float luma = getLuma(tex.rgb);
	float value = dither(uv * resolution, luma);

	fragColor = vec4(vec3(value), 1.0);
}