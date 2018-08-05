#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define offset 43758.5453123
uniform sampler2D texture;
uniform float time;
uniform float intensity;

in vec4 vertTexCoord;
out vec4 fragColor;

//RANDOM
float random(vec2 tex){
	//return fract(sin(x) * offset);
	return fract(sin(dot(tex.xy, vec2(12.9898, 78.233))) * offset);
}

float random(vec3 tex){
	//return fract(sin(x) * offset);
	return fract(sin(dot(tex.xyz, vec3(12.9898, 78.233, 12.9898))) * offset);
}

//GRAIN
vec4 addGrain(vec2 uv, float time, float grainIntensity){
	float grain = random(fract(uv * time)) * grainIntensity;
	return vec4(vec3(grain), 1.0);
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 rgbaTex = texture(texture, vertTexCoord.xy);
	vec4 grain = addGrain(uv, time, intensity);

	fragColor = rgbaTex + grain;
}