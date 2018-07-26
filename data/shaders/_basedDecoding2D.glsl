#version 150
#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif

 //constants elements
const vec2 efactor = vec2(1.0, 255.0);
const vec2 dfactor = vec2(1.0/1.0, 1.0/255.0);
const float mask = 1.0/256.0;


uniform sampler2D texture;

in vec4 vertTexCoord;
out vec4 fragColor;


vec2 encodeRGBA16(float v){
	vec2 rg = v * efactor;
	rg.g = fract(rg.g);
	rg.r -= rg.g * mask;
	return vec2(rg);
}

vec4 encodeRGBA1616(vec2 xy){
	vec4 encodedData = vec4(encodeRGBA16(xy.x), encodeRGBA16(xy.y));
	encodedData.a = 1.0;
	return encodedData;
}

vec2 decodeRGBA16(vec4 rgba){
	return vec2(dot(rgba.rg, dfactor), dot(rgba.ba, dfactor));
}


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);

	vec2 data = decodeRGBA16(tex);
	vec4 encodedData = encodeRGBA1616(data);

	fragColor = encodedData;
}