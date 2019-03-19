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

const int bayer3x3[9] = int[](0, 7, 3,
							  6, 5, 2,
							  4, 1, 8);


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
	int x  = int(mod(screenpos.x, 3));
	int y  = int(mod(screenpos.y, 3));
	return (1.0 + bayer3x3[(x + y * 3)]) / (9.0 + 1.0);
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
	float value = dither(uv * resolution, luma);

	fragColor = vec4(vec3(value), 1.0);
}