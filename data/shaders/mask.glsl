#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D mask;

out vec4 fragColor;

void main(){
	vec2 uv = vertTexCoord.xy; 
	vec4 rgbTop = texture(texture, uv);
	vec4 rgbBackColor = vec4(1., 1., 1., 0.0);
	vec4 rgbBackTex = vec4(texture(backTexture, uv).rgb, 0.0);
	vec4 rgbBack = mix(rgbBackColor, rgbBackTex, type);

	vec4 a = texture(mask, uv);

	vec4 color = mix(rgbBack, rgbTop, smoothstep(0.5, 0.8, a.r));
	//vec4 color = rgbTop * a.r + (1. - a.r) * rgbBack;
	//vec4 color = rgbd + a * (rgbs - rgbd);

	fragColor =  color;
}