#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D lut;

in vec4 vertTexCoord;
out vec4 fragColor;

vec4 lookUp(vec4 color, sampler2D lut1d){
	vec3 colorLookedUp = vec3(texture2D(lut1d, vec2(color.r, 0.5)).r,
							  texture2D(lut1d, vec2(color.g, 0.5)).g,
							  texture2D(lut1d, vec2(color.b, 0.5)).b);
	return vec4(colorLookedUp, color.a);
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);
	vec4 lookedUpColor = lookUp(tex, lut);

	fragColor = lookedUpColor;
}