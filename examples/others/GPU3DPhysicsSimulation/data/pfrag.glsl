#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

in vec4 vertColor;
in vec4 vertTexCoord;

out vec4 fragColor;


void main() {
  fragColor = vertColor;
}