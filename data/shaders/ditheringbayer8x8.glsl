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

const int bayer8x8[64] = int[](0,  32, 8,  40, 2,  34, 10, 42,
                              48, 16, 56, 24, 50, 18, 58, 26,
                              12, 44, 4,  36, 14, 46, 6,  38,
                              60, 28, 52, 20, 62, 30, 54, 22,
                              3,  35, 11, 43, 1,  33, 9,  41,
                              51, 19, 59, 27, 49, 17, 57, 25,
                              15, 47, 7,  39, 13, 45, 5,  37,
                              63, 31, 55, 23, 61, 29, 53, 21);


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
	return (1.0 + bayer8x8[(x + y * 8)]) / (64.0 + 1.0);
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