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
uniform float mouse;

in vec4 vertTexCoord;
out vec4 fragColor;

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}


float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

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
	float luma = getLuma(tex.rgb);


 	uv -= vec2(0.5);
    // rotate the space
    uv = rotate2d( mouse ) * uv;
    // move it back to the original place
    uv += vec2(0.5);


	float value = dither(uv * resolution, luma);

	fragColor = vec4(vec3(value), 1.0);
}