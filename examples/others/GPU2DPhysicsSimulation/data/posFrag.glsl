#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D otexture;

in vec4 vertColor;
in vec4 vertTexCoord;

out vec4 fragColor;


void main() {
  fragColor =texture2D(texture, vertTexCoord.xy);
}