
#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float level;

in vec4 vertTexCoord;
out vec4 fragColor;

//based on the tutorial : https://learnopengl.com/#!Advanced-Lighting/Bloom
vec4 getBright(vec3 color_, float threshold_){
	float brightness = dot(color_.rgb, vec3(0.2126, 0.7152, 0.0722));
	float inc = step(threshold_, brightness);
	return vec4(color_ * inc, 1.0);
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);
	vec4 threshold = getBright(tex.rgb, level);
	threshold.rgb = 1.0 - step(threshold.rgb, vec3(0.0));

	fragColor = threshold;
}