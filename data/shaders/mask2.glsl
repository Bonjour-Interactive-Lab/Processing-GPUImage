#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D base;
uniform sampler2D mask;

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	vec2 uv = vertTexCoord.xy; 
	vec4 tex = texture2D(texture, uv);
	vec4 texBase = texture2D(base, uv);
	float alpha = texture2D(mask, uv).r;
	vec4 finalColor = mix(texBase, tex, alpha);

	fragColor =  finalColor;
}