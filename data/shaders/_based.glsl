#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

in vec4 vertTexCoord;
out vec4 fragColor;

vec4 Desaturate(vec3 color, float Desaturation)
{
	vec3 grayXfer = vec3(0.3, 0.59, 0.11);
	vec3 gray = vec3(dot(grayXfer, color));
	return vec4(mix(color, gray, Desaturation), 1.0);
}



void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);

	fragColor = tex;
}