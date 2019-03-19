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


#define PI 3.14159265359

const int nonRectangular8x7[56] = int[](1, 6, 0, 5, 3, 4, 2, 7,
									 	4, 2, 7, 1, 6, 0, 5, 3, 
									 	0, 5, 3, 4, 2, 7, 1, 6,
									 	7, 1, 6, 0, 5, 3, 4, 2,
									 	3, 4, 2, 7, 1, 6, 0, 5,
									 	6, 0, 5, 3, 4, 2, 7, 1,
									 	2, 7, 1, 6, 0, 5, 3, 4);


uniform sampler2D texture;
uniform vec2 resolution;
uniform float theta;

in vec4 vertTexCoord;
out vec4 fragColor;

mat2 rotate2D(float angle){
	return mat2( cos(angle), -sin(angle),
				 sin(angle),  cos(angle));
}

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

float index(vec2 screenpos){
	int x  = int(mod(screenpos.x, 8));
	int y  = int(mod(screenpos.y, 7));
	return (1.0 + nonRectangular8x7[(x + y * 8)]) / (8.0);
}

float dither(vec2 screenpos, float lum){
	float d = index(screenpos);
	return step(d, lum);
}


void main(){
	vec2 uv = vertTexCoord.xy;

	vec4 tex = texture(texture, uv);

	//rotate uv
	uv -= vec2(0.5, 0.5);
    uv = rotate2D(theta) * uv;
    uv += vec2(0.5, 0.5);

	float luma = getLuma(tex.rgb);
	float value = dither(uv * resolution * 1.0, luma);

	fragColor = vec4(vec3(value), 1.0);
}