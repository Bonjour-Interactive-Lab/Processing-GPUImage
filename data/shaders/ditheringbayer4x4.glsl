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

const int bayer4x4[16] = int[](0,  8,  2, 10,
							  12,  4, 14,  6,
							   3, 11,  1,  9,
							  15,  7, 13,  5);


uniform sampler2D texture;
uniform vec2 resolution;

in vec4 vertTexCoord;
out vec4 fragColor;

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

float index(vec2 screenpos){
	int x  = int(mod(screenpos.x, 4));
	int y  = int(mod(screenpos.y, 4));
	return (1.0 + bayer4x4[(x + y * 4)]) / (16.0 + 1.0);
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