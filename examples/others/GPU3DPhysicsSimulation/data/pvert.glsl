#ifdef GL_ES
precision highp float;
precision highp vec2;
precision highp vec3;
precision highp vec4;
precision highp int;
#endif

const vec4 efactor = vec4(1.0, 255.0, 65025.0, 16581375.0);
const vec4 dfactor = vec4(1.0/1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
const float mask = 1.0/256.0;

uniform mat4 projection;
uniform mat4 modelview;

uniform sampler2D posBuffer;
uniform vec2 bufferResolution;
uniform vec2 gridResolution;
uniform vec3 worldResolution;

uniform float debug;


in vec4 position;
in vec3 normal;
in vec4 color;
in vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;

vec4 encodeRGBA24(float v){
	vec3 rgb = v * efactor.rgb;
	rgb.gb = fract(rgb.gb);
	rgb.rg -= rgb.gb * mask;
	return vec4(rgb, 1.0);
}

vec4 encodeRGBA32(float v){
	vec4 rgba = v * efactor.rgba;
	rgba.gba = fract(rgba.gba);
	rgba.rgb -= rgba.gba * mask;
	return rgba;
}

float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}

float decodeRGBA24(vec3 rgb){
	return dot(rgb, dfactor.rgb);
}

vec3 getData(vec2 screenPosition, vec2 gridResolution, vec2 samplerResolution, sampler2D dataSampler){
	//vec2 uv0 = position.xy/gridResolution;	
	float i0 = ((screenPosition.x + screenPosition.y * gridResolution.x) * 3.0 + 0.0);
	float i1 = (i0 + 1.0);
	float i2 = (i0 + 2);

	float ux = (mod(i0, samplerResolution.x));
	float vx = ((i0 - ux) / samplerResolution.x);

	float uy = (mod(i1, samplerResolution.x));
	float vy = ((i1 - uy) / samplerResolution.x);

	float uz = (mod(i2, samplerResolution.x));
	float vz = ((i2 - uz) / samplerResolution.x);

	//we need to offset the buffer res by -1 in order to get the first pixel 0
	vec2 uvx = vec2(ux, vx) / (samplerResolution - vec2(1.0));
	vec2 uvy = vec2(uy, vy) / (samplerResolution - vec2(1.0));
	vec2 uvz = vec2(uz, vz) / (samplerResolution - vec2(1.0));

	float x = decodeRGBA24(texture(dataSampler, uvx).rgb);
	float y = decodeRGBA24(texture(dataSampler, uvy).rgb);
	float z = decodeRGBA24(texture(dataSampler, uvz).rgb);

	return vec3(x, y, z);
}

void shufflePos(inout vec3 pos){
	pos.xyz = pos.zxy;
}

void main(){

	vec3 posData = getData(position.xy, gridResolution, bufferResolution, posBuffer) * 2.0 - 1.0;
	posData *= worldResolution;
	shufflePos(posData);

	vec4 clip = projection * modelview * vec4(posData, 1.0);
	gl_Position = clip + projection * vec4(offset.xy, 0, 0);

	vertColor = color;
}