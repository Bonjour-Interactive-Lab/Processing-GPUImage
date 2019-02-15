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

const int clusterDot5x3[15] = int[]( 9,  3,  0,  6, 12,
									10,  4,  1,  7, 13,
									11,  5,  2,  8, 14);

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
	int x  = int(mod(screenpos.x, 5));
	int y  = int(mod(screenpos.y, 3));
	return (1.0 + clusterDot5x3[(x + y * 5)]) / (15.0 + 1.0);
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