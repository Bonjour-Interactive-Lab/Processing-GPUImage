
#version 150
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

uniform mat4 transform;
uniform mat4 projection;
uniform mat4 modelview;

uniform sampler2D posBuffer;
uniform vec2 bufferResolution;
uniform vec2 gridResolution;
uniform vec3 worldResolution;


in vec4 position;
in vec3 normal;
in vec4 color;
in vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;


float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor);
}



void main(){

	//vec3 pos = getVector(position.xy, bufferResolution, vec3(1000.0), posBuffer);
	vec2 bufferRes = bufferResolution / vec2(1.0, 3.0);
	vertTexCoord.xy = position.xy / (bufferResolution.xy - vec2(1.0)) ;
	vec2 inc = vec2(0.0, 1.0/3.0);

	vec4 ex = texture2D(posBuffer, vertTexCoord.xy + inc * 0.0);
	vec4 ey = texture2D(posBuffer, vertTexCoord.xy + inc * 1.0);
	vec4 ez = texture2D(posBuffer, vertTexCoord.xy + inc * 2.0);

	float x = decodeRGBA32(ex);// * 2.0 - 1.0;
	float y = decodeRGBA32(ey);// * 2.0 - 1.0;
	float z = decodeRGBA32(ez);// * 2.0 - 1.0;

	vec3 pos = vec3(x, y, z) * 2.0 - 1.0;

	vec4 clip = projection * modelview * vec4(pos * worldResolution, 1.0);
	gl_Position = clip + projection * vec4(offset.xy * 0.25, 0, 0);

	vertColor = color;//vec4(x, y, z, 1.0);

}