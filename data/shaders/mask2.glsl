#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D base;
uniform sampler2D mask;
uniform int srci = 0;
uniform int basei = 0;
uniform int base2i = 0;

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	vec2 uv = vertTexCoord.xy; 
	vec2 iuv = vec2(uv.x, 1.0 - uv.y);
	vec4 tex = texture2D(texture, uv * (1 - basei) + iuv * basei);
	vec4 texBase = texture2D(base, uv * (1 - base2i) + iuv * base2i);
	float alpha = texture2D(mask, uv * (1 - srci)  + iuv * srci).r;
	vec4 finalColor = mix(texBase, tex, alpha);

	fragColor =  finalColor;
}