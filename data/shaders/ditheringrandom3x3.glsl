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

in vec4 vertTexCoord;
out vec4 fragColor;

float random(vec2 tex){
	//return fract(sin(x) * offset);
	return fract(sin(dot(tex.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

float index(vec2 screenpos){
	int x  = int(mod(screenpos.x, 3));
	int y  = int(mod(screenpos.y, 3));
	int rand = (9 * int(floor(random(vertTexCoord.xy) * 6))) / 4;
	return (1.0 + random3x3[rand + (x + y * 3)]) / (9.0 + 1.0);
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