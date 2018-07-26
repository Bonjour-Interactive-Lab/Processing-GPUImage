#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D ramp;

in vec4 vertTexCoord;
out vec4 fragColor;

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

vec4 getRamp(float luma, sampler2D ramp1d){
	vec3 colorRamped = texture2D(ramp1d, vec2(luma, 0.5)).rgb;
	return vec4(colorRamped, 1.0);
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);
	float luma = getLuma(tex.rgb);
	vec4 colorRamped = getRamp(luma, ramp);

	fragColor = colorRamped;
}