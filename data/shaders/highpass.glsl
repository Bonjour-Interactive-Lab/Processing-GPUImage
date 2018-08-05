#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;
uniform float sharpFactor = 1.0;

in vec4 vertTexCoord;
out vec4 fragColor;

#define highpass(i) 	tmp = texture(texture, uv + offsetTable[i]); sum += tmp * kernel[i]; sum.a = 1.0;

vec4 highPass(sampler2D texture, vec2 uv, float stepInc){
	//highPass
	float step_w = 1.0/ (resolution.x * stepInc);
	float step_h = 1.0/ (resolution.y * stepInc);

	vec2 offsetTable[9];
	float kernel[9];

	offsetTable[0] = vec2(-step_w, -step_h);
	offsetTable[1] = vec2(0.0, -step_h);
	offsetTable[2] = vec2(step_w, -step_h);

	offsetTable[3] = vec2(-step_w, 0.0);
	offsetTable[4] = vec2(0.0, 0.0);
	offsetTable[5] = vec2(step_w, 0.0);

	offsetTable[6] = vec2(-step_w, step_h);
	offsetTable[7] = vec2(0.0, step_h);
	offsetTable[8] = vec2(step_w, step_h);

	kernel[0] = -1.;
	kernel[1] = -1.;
	kernel[2] = -1.;
	
	kernel[3] = -1.;
	kernel[4] = 8.;
	kernel[5] = -1.;
	
	kernel[6] = -1.;
	kernel[7] = -1.;
	kernel[8] = -1.;

   //int i = 0;
   vec4 sum = vec4(0.0);
   vec4 tmp= vec4(0.0);

   highpass(0);
   highpass(1);
   highpass(2);
   highpass(3);
   highpass(4);
   highpass(5);
   highpass(6);
   highpass(7);
   highpass(8);

   //map from 0 to 1 to 0.5 to 1
   return sum * 0.5 + 0.5;
}

void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = highPass(texture, uv, sharpFactor);

	fragColor = tex;
}