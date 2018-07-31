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

uniform mat4 projection;
uniform mat4 modelview;

uniform sampler2D posBuffer;
uniform sampler2D massBuffer;
uniform vec2 worldResolution = vec2(1280, 720);
uniform vec2 bufferResolution;
uniform float maxMass;
uniform float minMass;

in vec4 position;
in vec4 color;
in vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;

float decodeRGBA16(vec2 rg){
  return dot(rg, dfactor.rg);
}

vec2 decodeRGBA16(vec4 rgba){
  return vec2(decodeRGBA16(rgba.rg), decodeRGBA16(rgba.ba));
}

float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}

void main(){
	/*
	//Old method using RGBA color to retrive index
	float index = decodeRGBA32(color) * (bufferResolution.x * bufferResolution.y);
	float x = mod(index, bufferResolution.x);
	float y = (index - x) / bufferResolution.x;
	vec2 uv = vec2(x, y) / bufferResolution;
	vertTexCoord = vec4(uv, 0.0, 1.0);
	*/
	vertTexCoord.xy = position.xy / bufferResolution.xy;
	vertTexCoord.zw = vec2(0.0, 1.0);

   	//get the data into texture
   	vec4 posRGBA = texture2D(posBuffer, vertTexCoord.xy);
   	vec4 massRGBA = texture2D(massBuffer, vertTexCoord.xy);
  	//decode the data 
  	vec2 pos = decodeRGBA16(posRGBA) * worldResolution;
  	float mass = minMass + decodeRGBA32(massRGBA) * (maxMass - minMass);

	vec4 clip = projection * modelview * vec4(pos, 0.0, 1.0);
	gl_Position = clip + projection * vec4(offset.xy * vec2(mass), 0, 0);

	vertColor = color;
}