#version 150
#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif

const vec4 efactor = vec4(1.0, 255.0, 65025.0, 16581375.0);
const vec4 dfactor = vec4(1.0/1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
const float mask = 1.0/256.0;

uniform sampler2D texture;
uniform sampler2D posBuffer;
uniform vec2 bufferResolution;
uniform vec3 worldResolution = vec3(1.0);
uniform vec3 gravity = vec3(0.0, 0.1, 0.0);
uniform vec3 wind = vec3(0.0);
uniform float maxVel;
uniform float maxMass;

in vec4 vertColor;
in vec4 vertTexCoord;

out vec4 fragColor;


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


vec3 getInterleavedXYZ(float index){
	//check the type of the fragment using %3 where 0 = x, 1 = y and z = 2
	float modi = floor(mod(index, 3.0));

	//define stepper
	float isX = 1.0 - step(1.0, modi);
	float isZ = step(2.0, modi);
	float isY = 1.0 - (isX + isZ);

	return vec3(isX, isY, isZ);
}

void getInterleavedXYZUV(inout vec2 array[6], float index, vec2 samplerResolution){
	//define other index per fragment
	//if x
	float ix1 = index + 1;
	float ix2 = index + 2;
	//if y
	float iy1 = index - 1;
	float iy2 = index + 1;
	//if z
	float iz1 = index - 2;
	float iz2 = index - 1;

	//define all the uv coord
	//if x
	float uxy = round(mod(ix1, samplerResolution.x));
	float vxy = round((ix1 - uxy) / samplerResolution.x);

	float uxz = round(mod(ix2, samplerResolution.x));
	float vxz = round((ix2 - uxz) / samplerResolution.x);

	//if y
	float uyx = round(mod(iy1, samplerResolution.x));
	float vyx = round((iy1 - uyx) / samplerResolution.x);

	float uyz = round(mod(iy2, samplerResolution.x));
	float vyz = round((iy2 - uyz) / samplerResolution.x);
	//if z
	float uzx = round(mod(iz1, samplerResolution.x));
	float vzx = round((iz1 - uzx) / samplerResolution.x);

	float uzy = round(mod(iz2, samplerResolution.x));
	float vzy = round((iz2 - uzy) / samplerResolution.x);

	array[0] = vec2(uxy, vxy) / samplerResolution;
	array[1] = vec2(uxz, vxz) / samplerResolution;

	array[2] = vec2(uyx, vyx) / samplerResolution;
	array[3] = vec2(uyz, vyz) / samplerResolution;

	array[4] = vec2(uzx, vzx) / samplerResolution;
	array[5] = vec2(uzy, vzy) / samplerResolution;
}

vec3 getData(vec2 uvs[6], sampler2D samplerData, vec4 fragmentData, vec3 is){
	//get all the samplers per fragment
	vec4 RGBAX = 			   fragmentData * is.x + texture2D(texture, uvs[2]) * is.y + texture2D(texture, uvs[4]) * is.z;
	vec4 RGBAY = texture2D(texture, uvs[0]) * is.x + 			   fragmentData * is.y + texture2D(texture, uvs[5]) * is.z;
	vec4 RGBAZ = texture2D(texture, uvs[1]) * is.x + texture2D(texture, uvs[3]) * is.y + 			   fragmentData * is.z;

	float x = decodeRGBA24(RGBAX.rgb);
	float y = decodeRGBA24(RGBAY.rgb);
	float z = decodeRGBA24(RGBAZ.rgb);

	return vec3(x, y, z);
}

void main() {
	vec4 prevVelRGBA = texture2D(texture, vertTexCoord.xy);
	vec4 posRGBA = texture2D(posBuffer, vertTexCoord.xy);

	//compute the index of the fragment on the buffer
	vec2 screenCoord = vertTexCoord.xy * bufferResolution;
	float i0 = ceil(screenCoord.x + screenCoord.y * bufferResolution.x);

	//check the type of the fragment using %3 where 0 = x, 1 = y and z = 2
	vec3 is = getInterleavedXYZ(i0);
	//define other index per fragment
	vec2 uvs[6];
	getInterleavedXYZUV(uvs, i0, bufferResolution);

	//get all the samplers per fragment
	vec3 acc = vec3(0.0);
	vec3 vel = (getData(uvs, texture, prevVelRGBA, is) * 2.0 - 1.0) * maxVel;
	vec3 loc = (getData(uvs, posBuffer, posRGBA, is) * 2.0 - 1.0) * worldResolution;
	float mass = maxMass;

	//define friction
	float coeff = 0.35;
	vec3 friction = normalize(vel * -1.0) * coeff;

	//add force
	acc += wind/mass;
	acc += friction / mass;
	acc += gravity;

	//add acc to vel
	vel += acc;
	vel = clamp(vel, -vec3(maxVel), vec3(maxVel)); //clamp velocity to max force

	loc += vel;

	//edge condition
	float edgeXL = 1.0 - step(-worldResolution.x, loc.x);// if x < 0 : 1.0 else 0.0
	float edgeXR = step(worldResolution.x, loc.x);// if x > 1.0 : 1.0 else 0.0;
	float edgeX = (1.0 - (edgeXL + edgeXR)) * 2.0 - 1.0; // 0<x<1 : 0.0 else -1.0<1.0;
	float edgeYT = 1.0 - step(-worldResolution.y, loc.y);// if x < 0 : 1.0 else 0.0
	float edgeYB = step(worldResolution.y, loc.y);// if x > 1.0 : 1.0 else 0.0;
	float edgeY = (1.0 - (edgeYT + edgeYB)) * 2.0 - 1.0; // 0<x<1 : 0.0 else -1.0<1.0;
	float edgeZT = 1.0 - step(-worldResolution.z, loc.z);// if x < 0 : 1.0 else 0.0
	float edgeZB = step(worldResolution.z, loc.z);// if x > 1.0 : 1.0 else 0.0;
	float edgeZ = (1.0 - (edgeZT + edgeZB)) * 2.0 - 1.0; // 0<x<1 : 0.0 else -1.0<1.0;
	vel.x *= edgeX;
	vel.y *= edgeY;
	vel.z *= edgeZ;

	vel /= maxVel; //we normalize velocity
	vel = (vel * 0.5) + 0.5; //reset it from[-1, 1] to [0.0, 1.0]
	vel = clamp(vel, 0, 1.0); //we clamp the velocity between [0, 1] (this is a security)

	vec4 newVelEncoded = encodeRGBA24(vel.x) * is.x + 
						 encodeRGBA24(vel.y) * is.y + 
						 encodeRGBA24(vel.z) * is.z;

  	fragColor = newVelEncoded;
}