#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif

uniform sampler2D texture;
uniform int dataMax;

in vec4 vertTexCoord;
out vec4 fragColor;


vec4 encodeRGBAMod(float value, float edge){
	float divider = float(edge) / 256.0;

	float modValue = mod(value, 255.0);
	float modIndex = value / 255.0;

	float index = modIndex / divider;
	float luma = fract(modValue);

	return vec4(luma, luma, index, 1.0);
}

float decodeRGBAMod(vec4 rgba, float edge){
	float divider = float(edge) / 256.0;
	float index = round(rgba.b * divider);

	return rgba.r + 255 * index;
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);

	float data = decodeRGBAMod(tex, dataMax);
	vec4 encodedData = encodeRGBAMod(data, float(dataMax));

	fragColor = encodedData;
}