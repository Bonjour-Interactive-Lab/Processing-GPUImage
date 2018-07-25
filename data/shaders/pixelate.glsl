#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;
uniform float pixelRes = 100;

in vec4 vertTexCoord;
out vec4 fragColor;


void main(){
	float dx = 1.0 / pixelRes;
	float ratio = resolution.x / resolution.y;
	float dy = ratio / pixelRes;

	float u = floor(vertTexCoord.x / dx) * dx;
	float v = floor(vertTexCoord.y / dy) * dy;

	vec2 uv = vec2(u, v);
	vec4 tex = texture2D(texture, uv);

	fragColor = tex;
}