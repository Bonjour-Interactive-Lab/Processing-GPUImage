#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif

//constants elements
const vec4 efactor = vec4(1.0, 255.0, 65025.0, 16581375.0);
const vec4 dfactor = vec4(1.0/1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
const float mask = 1.0/256.0;


uniform sampler2D texture;

in vec4 vertTexCoord;
out vec4 fragColor;

vec4 encodeRGBA32(float v){
	vec4 rgba = v * efactor.rgba;
	rgba.gba = fract(rgba.gba);
	rgba.rgb -= rgba.gba * mask;
	rgba.a = 1.0;
	return rgba;
}

vec4 encodeRGBA24(float v){
	vec3 rgb = v * efactor.rgb;
	rgb.gb = fract(rgb.gb);
	rgb.rg -= rgb.gb * mask;
	return vec4(rgb, 1.0);
}

vec4 encodeRGBA16(float v){
	vec2 rg = v * efactor.rg;
	rg.g = fract(rg.g);
	rg.r -= rg.g * mask;
	return vec4(rg, 0.0, 1.0);
}

float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}

float decodeRGBA24(vec3 rgb){
	return dot(rgb, dfactor.rgb);
}

float decodeRGBA16(vec2 rg){
	return dot(rg, dfactor.rg);
}


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);

	float data = decodeRGBA32(tex);
	vec4 encodedData = encodeRGBA32(data);

	fragColor = encodedData;
}