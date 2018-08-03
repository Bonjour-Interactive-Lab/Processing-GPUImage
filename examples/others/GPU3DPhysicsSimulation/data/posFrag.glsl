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
uniform sampler2D velBuffer;
uniform sampler2D maxVelBuffer;
uniform vec2 singleBufferResolution;
uniform vec2 bufferResolution;
uniform vec3 worldResolution = vec3(1.0);
uniform float maxVel;
uniform float minVel;
uniform vec3 obstacle;
uniform float obstacleSize;

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

vec2 getSingleDataUV(float index, vec2 samplerResolution){
	float pindex = floor(index / 3.0);

	float u = round(mod(pindex, samplerResolution.x));
	float v = round((pindex - u) / samplerResolution.x);

	return vec2(u, v)/samplerResolution;
}


void main() {
	/**
	 * The XYZ seems shuffled into ZXY. its messed up
	 */

	//compute the index of the fragment on the buffer
	vec2 screenCoord = vertTexCoord.xy * bufferResolution;
	float i0 = (screenCoord.x + screenCoord.y * bufferResolution.x);
	vec2 singleDataUV = getSingleDataUV(i0, singleBufferResolution);

	vec4 prevPosRGBA = texture2D(texture, vertTexCoord.xy);
	vec4 velRGBA = texture2D(velBuffer, vertTexCoord.xy);
	vec4 maxVelRGBA = texture2D(maxVelBuffer, singleDataUV);

/*
	//check the type of the fragment using %3 where 0 = x, 1 = y and z = 2
	float modi = floor(mod(i0, 3.0));

	//define stepper
	float isX = 1.0 - step(1.0, modi);
	float isZ = step(2.0, modi);
	float isY = 1.0 - (isX + isZ);


	//define other index per fragment
	//if x
	float ix1 = i0 + 1;
	float ix2 = i0 + 2;
	//if y
	float iy1 = i0 - 1;
	float iy2 = i0 + 1;
	//if z
	float iz1 = i0 - 2;
	float iz2 = i0 - 1;

	//define all the uv coord
	//if x
	float uxy = round(mod(ix1, bufferResolution.x));
	float vxy = round((ix1 - uxy) / bufferResolution.x);

	float uxz = round(mod(ix2, bufferResolution.x));
	float vxz = round((ix2 - uxz) / bufferResolution.x);

	//if y
	float uyx = round(mod(iy1, bufferResolution.x));
	float vyx = round((iy1 - uyx) / bufferResolution.x);

	float uyz = round(mod(iy2, bufferResolution.x));
	float vyz = round((iy2 - uyz) / bufferResolution.x);
	//if z
	float uzx = round(mod(iz1, bufferResolution.x));
	float vzx = round((iz1 - uzx) / bufferResolution.x);

	float uzy = round(mod(iz2, bufferResolution.x));
	float vzy = round((iz2 - uzy) / bufferResolution.x);


	//get all the samplers per fragment
	//vec4 RGBAX = prevPosRGBA * isX + texture2D(texture, vec2(uyx, vyx)/bufferResolution) * isY + texture2D(texture, vec2(uzx, vzx)/bufferResolution) * isZ;
	//vec4 RGBAY = prevPosRGBA * isY + texture2D(texture, vec2(uxy, vxy)/bufferResolution) * isX + texture2D(texture, vec2(uzy, vzy)/bufferResolution) * isZ;
	//vec4 RGBAZ = prevPosRGBA * isZ + texture2D(texture, vec2(uxz, vxz)/bufferResolution) * isX + texture2D(texture, vec2(uyz, vyz)/bufferResolution) * isY;
	vec4 RGBAX = 										 prevPosRGBA * isX + texture2D(texture, vec2(uyx, vyx)/bufferResolution) * isY + texture2D(texture, vec2(uzx, vzx)/bufferResolution) * isZ;
	vec4 RGBAY = texture2D(texture, vec2(uxy, vxy)/bufferResolution) * isX + 										 prevPosRGBA * isY + texture2D(texture, vec2(uzy, vzy)/bufferResolution) * isZ;
	vec4 RGBAZ = texture2D(texture, vec2(uxz, vxz)/bufferResolution) * isX + texture2D(texture, vec2(uyz, vyz)/bufferResolution) * isY + 										 prevPosRGBA * isZ;

	float x = decodeRGBA24(RGBAX.rgb);
	float y = decodeRGBA24(RGBAY.rgb);
	float z = decodeRGBA24(RGBAZ.rgb);

	vec3 loc = vec3(x, y, z) * 2.0 - 1.0;

*/
	//check the type of the fragment using %3 where 0 = x, 1 = y and z = 2
	vec3 is = getInterleavedXYZ(i0);
	//define other index per fragment
	vec2 uvs[6];
	getInterleavedXYZUV(uvs, i0, bufferResolution);

	//get all the samplers per fragment
	float edgeVel = mix(minVel, maxVel,decodeRGBA24(maxVelRGBA.rgb));
	vec3 loc = (getData(uvs, texture, prevPosRGBA, is) * 2.0 - 1.0) * worldResolution;
	vec3 vel = (getData(uvs, velBuffer, velRGBA, is) * 2.0 - 1.0) * edgeVel;
	
	loc += vel;

	//edge
	loc /= worldResolution - vec3(0.0, 0.0, 0.0); //we reduce the world position of 0.1 in order to avoid infinite bounce on the ground
	loc = loc * 0.5 + 0.5;//Remap to range [0, 1];
	loc = clamp(loc, 0.0, 1.0);

	vec4 newPosEncoded = encodeRGBA24(loc.x) * is.x + 
						 encodeRGBA24(loc.y) * is.y + 
						 encodeRGBA24(loc.z) * is.z;


  	fragColor = newPosEncoded;
}