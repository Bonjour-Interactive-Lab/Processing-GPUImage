#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif


uniform sampler2D dataTexture;
uniform int dataMax;
uniform float time;

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

	return rgba.r *255.0 + 255.0 * index;
}


void main(){
	vec2 uv = vertTexCoord.xy;


	vec4 tex = texture(dataTexture, uv);

	float data = decodeRGBAMod(tex, dataMax) / float(dataMax);

	float distanceTex = 1.0 - smoothstep(0.0, 1.0, data);
	float target = fract(time);	
	vec3 DepthSlice = vec3(0.0);
	#define iteration 3
	float smoothing = 0.1 / float(iteration);
	float thickness = 0.25 / float(iteration);
	for(int i=0; i<iteration; i++){
		float fi = float(i) / float(iteration);
		float targeti = fract(fi + target) * pow(distanceTex, 0.05);
		float df1 = smoothstep((targeti - thickness * 0.5) - smoothing, (targeti - thickness * 0.5) + smoothing, 1.0 - distanceTex);
		float df2 = smoothstep((targeti + thickness * 0.5) - smoothing, (targeti + thickness * 0.5) + smoothing, 1.0 - distanceTex);
		float df = df1 - df2;
		DepthSlice += vec3(df);
	}

	vec3 RGB = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 1.0), DepthSlice.r * pow(distanceTex, 1.15)) * pow(DepthSlice.r, 1.5);
	vec4 RGBA = vec4(RGB + vec3(0.05, 0.0, 0.25), 1.0) * 1.25;


	fragColor = RGBA;
}