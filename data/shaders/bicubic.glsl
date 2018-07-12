#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


uniform sampler2D texture;
uniform vec2 resolution;
in vec4 vertTexCoord;

out vec4 fragColor;

void main(){
	fragColor = vec4(1.0);
}