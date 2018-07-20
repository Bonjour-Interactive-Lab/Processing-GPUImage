
#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	vec2 uv = vertTexCoord.xy;

	fragColor = vec4(uv.x, uv.x, uv.x, 1.0);
}