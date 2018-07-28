#version 150
#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif

const vec2 efactor = vec2(1.0, 255.0);
const vec2 dfactor = vec2(1.0/1.0, 1.0/255.0);
const float mask = 1.0/256.0;

uniform sampler2D texture;
uniform sampler2D velBuffer;
uniform vec2 worldResolution;
uniform float maxVel;

in vec4 vertColor;
in vec4 vertTexCoord;

out vec4 fragColor;

vec2 encodeRGBA16(float v){
	vec2 rg = v * efactor;
	rg.g = fract(rg.g);
	rg.r -= rg.g * mask;
	return vec2(rg);
}

vec4 encodeRGBA1616(vec2 xy){
	vec4 encodedData = vec4(encodeRGBA16(xy.x), encodeRGBA16(xy.y));
	encodedData.a = 1.0;
	return encodedData;
}

vec2 decodeRGBA16(vec4 rgba){
	return vec2(dot(rgba.rg, dfactor), dot(rgba.ba, dfactor));
}

void main() {
	vec4 prevPosRGBA = texture2D(texture, vertTexCoord.xy);
	vec4 velRGBA = texture2D(velBuffer, vertTexCoord.xy);

	vec2 loc = decodeRGBA16(prevPosRGBA) * worldResolution;
	//we remap vel from  [0, 1] to [-1, 1] in order to have -1.0 * velocity
	vec2 vel = (decodeRGBA16(velRGBA) * 2.0 - 1.0) * maxVel;

	loc += vel;

	//edge
	loc /= worldResolution;
	loc = clamp(loc, 0.0, 1.0);

	vec4 newPosEncoded = vec4(encodeRGBA16(loc.x), encodeRGBA16(loc.y));

  	fragColor = newPosEncoded;
}