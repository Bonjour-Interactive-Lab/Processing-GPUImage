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


in vec4 position;
in vec4 color;
in vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;


float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}

vec3 getData(vec2 position, vec2 resolution, sampler2D dataTex){
	int i = int(position.x) + int(position.y) * int(resolution) / 3;
	int ix = i * 3 + 0;
	int iy = i * 3 + 1;
	int iz = i * 3 + 2;

	//transform index of XYZ component to uv coordinate
	float ux = mod(ix, resolution.x);
	float vx = (ix - ux) / resolution.x;

	float uy = mod(iy, resolution.x);
	float vy = (iy - uy) / resolution.x;

	float uz = mod(iz, resolution.x);
	float vz = (iz - uz) / resolution.x;

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
	int modulo = int(mod(index, 3));
	float stepX = 1.0 - step(1.0, float(modulo));//if mod == 0.0 : 1.0 : 0.0
	float stepY = step(1.0, float(modulo));// - ;//if mod > 0.0 : 1.0 : 0.0
	float stepZ = step(2.0, float(modulo));//if mod > 1.0 : 1.0 : 0.0
	vec3 col = vec3(1.0 * stepX, 1.0 * stepY - stepZ, 1.0 * stepZ); 
	float luma = float(index) / ((bufferResolution.x * bufferResolution.y)/3.0);
	float lumaStep = step(1.0, luma);


	//vec3 pos = getData(position.xy, bufferResolution, posBuffer);



	vec4 clip = projection * modelview * position;//vec4(pos, 1.0);//position;//;
	gl_Position = clip + projection * vec4(offset.xy, 0, 0);

	vertColor =	vec4(col, 1.0);
}