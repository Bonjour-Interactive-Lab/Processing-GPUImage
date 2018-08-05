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

const int clusterDot4x4[16] = int[](12,  5,  6, 13,
								  	 4,  0,  1,  7,
								   	11,  3,  2,  8,
								  	15, 10,  9, 14);


uniform sampler2D texture;
uniform vec2 resolution;

in vec4 vertTexCoord;
out vec4 fragColor;


float index(vec2 screenpos){
	int x  = int(mod(screenpos.x, 4));
	int y  = int(mod(screenpos.y, 4));
	return (1.0 + clusterDot4x4[(x + y * 4)]) / (16.0 + 1.0);
}

float dither(vec2 screenpos, float lum){
	float d = index(screenpos);
	return step(d, lum);
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);
	float r = dither(uv * resolution, tex.r);
	float g = dither(uv * resolution, tex.g);
	float b = dither(uv * resolution, tex.b);

	fragColor = vec4(r, g, b, 1.0);
}