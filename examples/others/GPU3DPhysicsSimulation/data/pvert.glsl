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
uniform vec3 worldResolution;
uniform vec2 bufferResolution;
uniform float  res;


in vec4 position;
in vec4 color;
in vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;


float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}

vec3 getData(vec2 position, vec2 resolution, sampler2D dataTex){
	int i = int(ceil(position.x + position.y * resolution.x));
	int ix = i + 0;
	int iy = i + 1;
	int iz = i + 2;

	//transform index of XYZ component to uv coordinate
	int ux = int(floor(mod(ix, resolution.x)));
	int vx = int(floor((ix - ux) / resolution.x));

	int uy = int(floor(mod(iy, resolution.x)));
	int vy = int(floor((iy - uy) / resolution.x));

	int uz = int(floor(mod(iz, resolution.x)));
	int vz = int(floor((iz - uz) / resolution.x));

	vec2 uvx = vec2(ux, vx) / resolution;
	vec2 uvy = vec2(uy, vy) / resolution;
	vec2 uvz = vec2(uz, vz) / resolution;

	//get RGBA encoded data
	vec4 xRGBA = texture2D(dataTex, uvx);
	vec4 yRGBA = texture2D(dataTex, uvy);
	vec4 zRGBA = texture2D(dataTex, uvz);

	//decode data and remap them from [0, 1] to [-1, 1]
	float x = (decodeRGBA32(xRGBA) * 2.0 - 1.0);
	float y = (decodeRGBA32(yRGBA) * 2.0 - 1.0);
	float z = (decodeRGBA32(zRGBA) * 2.0 - 1.0); 

	//return position into world space
	return vec3(x, y, z) * worldResolution;
}

void main(){
	//debug color
	int pindex = int(floor(position.x + position.y * bufferResolution.x));
	int index = pindex / 3;
/*
	int modulo = int(mod(index, 3));
	float stepX = 1.0 - step(1.0, float(modulo));//if mod == 0.0 : 1.0 : 0.0
	float stepY = step(1.0, float(modulo));// - ;//if mod > 0.0 : 1.0 : 0.0
	float stepZ = step(2.0, float(modulo));//if mod > 1.0 : 1.0 : 0.0
	vec3 col = vec3(1.0 * stepX, 1.0 * stepY - stepZ, 1.0 * stepZ); 
	float luma = float(index) / ((bufferResolution.x * bufferResolution.y)/3.0);
	float lumaStep = step(1.0, luma);


	vec3 pos = getData(position.xy, bufferResolution, posBuffer);
*/
	/**
	* Debug step :
	* -[x] try a create a sphere by using index only
	* -[ ] Try to encode simple values (1.0, 1.0, 1.0) and decode it as color per vertex
	* -[ ] Try a display a array correspondance system on another sketch
	*/
	/**
	* Step 1 : create sphere on  shader side only
	*/
	/*
	#define PI 3.14159265359
	#define R 250
	int ux = int(floor(mod(pindex, bufferResolution.x)));
	int vx = int(floor((pindex - ux) / bufferResolution.x));

    float u = float(ux) / bufferResolution.x;
    float v = float(vx) / bufferResolution.y;

    float phi = u * PI;
    float theta = v * (PI * 2.0);

    float x = sin(phi) * cos(theta) * R;
    float y = sin(phi) * sin(theta) * R;
    float z = cos(phi) * R;

    vec4 tpos = vec4(x, y, z, 1.0);
*/
    /**
    * Step 2 : encode simple value as color (1.0, 1.0, 1.0)
    */

	float stepper = step(res, float(pindex)) * 0.5 + 0.5;

	float ppindex = (position.x + position.y * bufferResolution.x); //32.0 has been set as constant from P5 (w,h of partciles system)
    float ix = ppindex;
	float iy = ppindex + 1;
	float iz = ppindex + 2;


    float ux = mod(ix, bufferResolution.x);
	float vx = (ix - ux) / bufferResolution.x;

	float uy = mod(iy, bufferResolution.x);
	float vy = (iy - uy) / bufferResolution.x;

	float uz = mod(iz, bufferResolution.x);
	float vz = (iz - uz) / bufferResolution.x;

	vec2 uvx = vec2(ux, vx) / bufferResolution;
	vec2 uvy = vec2(uy, vy) / bufferResolution;
	vec2 uvz = vec2(uz, vz) / bufferResolution;

	//get RGBA encoded data
	vec4 xRGBA = texture2D(posBuffer, uvx);
	vec4 yRGBA = texture2D(posBuffer, uvy);
	vec4 zRGBA = texture2D(posBuffer, uvz);

	//decode data and remap them from [0, 1] to [-1, 1]
	float r = decodeRGBA32(xRGBA); //seems to be 0.25 and need to be 0.25
	float g = 0.5;//decodeRGBA32(yRGBA); //seems to be 0.25 and need to be 0.5
	float b = 0.75;//decodeRGBA32(zRGBA); //seems to be 0.5 and need to be 0.75


	vec4 clip = projection * modelview * position;
	gl_Position = clip + projection * vec4(offset.xy, 0, 0);

	vertColor =	vec4(r, g, b, 1.0) * stepper;
}