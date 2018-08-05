#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D mask;
uniform int srci = 0;
uniform int basei = 0;

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	vec2 uv = vertTexCoord.xy; 
	vec2 iuv = vec2(uv.x, 1.0 - uv.y);
	vec4 tex = texture(texture, uv * (1 - basei) + iuv * basei);
	vec4 rgbaBack = vec4(tex.bgr, 0.0);
	float alpha = texture(mask, uv * (1 - srci)  + iuv * srci).r;
	vec4 finalColor = mix(rgbaBack, tex, alpha);
	
	fragColor =  finalColor;
}