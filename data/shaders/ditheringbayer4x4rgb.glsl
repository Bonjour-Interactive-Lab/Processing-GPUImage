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

const int bayer4x4[16] = int[](0,  8,  2, 10,
							  12,  4, 14,  6,
							   3, 11,  1,  9,
							  15,  7, 13,  5);


uniform sampler2D texture;
uniform vec2 resolution;
uniform float theta;

in vec4 vertTexCoord;
out vec4 fragColor;

mat2 rotate2D(float angle){
	return mat2( cos(angle), -sin(angle),
				 sin(angle),  cos(angle));
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
	vec4 tex = texture(texture, uv);

	//rotate uv
	uv -= vec2(0.5, 0.5);
    uv = rotate2D(theta) * uv;
    uv += vec2(0.5, 0.5);
    
	float r = dither(uv * resolution, tex.r);
	float g = dither(uv * resolution, tex.g);
	float b = dither(uv * resolution, tex.b);

	fragColor = vec4(r, g, b, 1.0);
}