
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float levelRed = 0.0;
uniform float levelGreen = 0.0;
uniform float levelBlue = 0.0;

in vec4 vertTexCoord;
out vec4 fragColor;

//based on the tutorial : https://learnopengl.com/#!Advanced-Lighting/Bloom
vec4 getBright(vec3 color_, vec3 threshold_){
	vec3 inc = step(threshold_, color_);
	return vec4(color_ * inc, 1.0);
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);
	vec4 threshold = getBright(tex.rgb, vec3(levelRed, levelGreen, levelBlue));

	fragColor = threshold;
}