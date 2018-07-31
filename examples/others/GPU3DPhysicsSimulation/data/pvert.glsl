
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
uniform vec2 bufferResolution;
uniform vec2 gridResolution;


in vec4 position;
in vec3 normal;
in vec4 color;
in vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;


float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}

void main(){
	//debug color
	//int pindex = int(floor(position.x + position.y * bufferResolution.x));
	//int index = pindex / 3;
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
	
	//this uv is useful when we have the same amount of particles than buffer size
	vec2 semiTexel = (vec2(1.0) / bufferResolution) * vec2(0.5, 0.5);
	vec2 ouv = position.xy / (bufferResolution.xy - vec2(1.0)); //we had a semi pixel in order to get rid a the interpolation at edges
	vec4 rgba = texture2D(posBuffer, ouv);


	vec2 uv0 = position.xy/gridResolution;
	
	float i0 = ceil((position.x + position.y * gridResolution.x)) * 3.0 + 0.0;
	float i1 = i0 + 1;
	float i2 = i0 + 2;

	float ur = ceil(mod(i0, bufferResolution.x));
	float vr = ceil((i0 - ur) / bufferResolution.x);

	float ug = ceil(mod(i1, bufferResolution.x));
	float vg = ceil((i1 - ug) / bufferResolution.x);

	float ub = ceil(mod(i2, bufferResolution.x));
	float vb = ceil((i2 - ub) / bufferResolution.x);

	//we need to offset the buffer res by -1 in order to get the first pixel 0
	vec2 uvr = vec2(ur, vr) / (bufferResolution - vec2(1.0));
	vec2 uvg = vec2(ug, vg) / (bufferResolution - vec2(1.0));
	vec2 uvb = vec2(ub, vb) / (bufferResolution - vec2(1.0));


	vec4 ered = texture2D(posBuffer, uvr, 0.0);
	vec4 egreen = texture2D(posBuffer, uvg, 0.0);
	vec4 eblue = texture2D(posBuffer, uvb, 0.0);

	float red = decodeRGBA32(ered);
	float green = decodeRGBA32(egreen);
	float blue = decodeRGBA32(eblue);

	vec3 index = vec3(i0 / (gridResolution.x * gridResolution.y));


	vec4 clip = projection * modelview * vec4(ur, vr, 0.0, 1.0);//vec4(uvr, 0.0, 1.0);//position;
	gl_Position = clip + projection * vec4(offset.xy, 0, 0);

	vertColor = vec4(red, green, blue, 1.0);// + vec4(position.xy / bufferResolution.xy, 0.0, 1.0);//vec4(uvr / bufferResolution, 0.0, 1.0);//vec4(uv0, 0.0, 1.0);

}