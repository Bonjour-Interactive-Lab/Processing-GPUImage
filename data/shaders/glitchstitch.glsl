//blend sources : http://wiki.polycount.com/wiki/Blending_functions

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
/*GLITCH VARIABLES*/
#define PI 3.1415926535897932384626433832795
#define TWOPI (PI * 2.0)
uniform float time;
uniform float intensity = 0.5;
#define INVERTINTENSITY (1.0 - intensity)
uniform vec2 colsrows = vec2(2.0);
uniform float subdivision = 0.5;
uniform float breakTime = 1.0;
uniform float speedTime = 0.1;
uniform float frequency = 4.0;
uniform float amplitude = 0.1;


in vec4 vertTexCoord;
out vec4 fragColor;

/*Global functions*/
float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(10.9898,78.233)))*43758.5453123);
}

float getLuma(vec3 color_){
	return dot(color_.rgb, vec3(0.299, 0.587, 0.114));
}

vec4 grid(vec2 uv, vec2 colsrows){
	vec2 nuv = uv * colsrows;
	vec2 fuv = fract(nuv);
	vec2 iuv = floor(nuv);

	return vec4(fuv, iuv);
}

#define OCTAVE 2
vec4 subdivideGrid(vec4 igrid, float time, float edge){
	vec4  ogrid = igrid;
	float index = random(igrid.zw + time);
	float isSubdive = step(edge, index);

	for(int i=0; i<OCTAVE; i++){
		index = random(igrid.zw + ogrid.zw + random(igrid.zw * i));
		isSubdive = step(edge, index);
		igrid += mix(igrid, grid(igrid.xy, vec2(2.0, 2.0)), vec4(1.0 - isSubdive));
	}	

	return igrid;
}

#define SPEED 0.0001
float animationTime(float edgeScale, float speedScale){
	float randTimeEdge = random(floor(vec2(time))) * edgeScale;
	float randAnimation = step(randTimeEdge, fract(time));
	return colsrows.x + colsrows.y + time * randAnimation * SPEED * speedScale; 
}

/*WAVE*/
vec2 waveUV(vec2 uv, vec2 colsrows, float frequence, float amplitude, float time, float index, float edge){
	vec2 nuv 		= uv * colsrows;
	vec2 iuv 		= floor(nuv);
	float offset 	= step(edge, index);
	float freqEdge	= step(0.001, frequence);
	float freq   	= frequence * freqEdge + 1.0 * (1.0 - freqEdge);
	float wave 		= sin(time + (mod(iuv.y, freq) / freq) * PI * 2.0) * (1.0 - edge);
  	wave 		   *= 10.0;
  	wave            = floor(wave);
  	wave           *= 0.1; 
  	return mix(uv, vec2(uv.x + wave * amplitude, uv.y), vec2(offset));
}

/*INVERT*/
vec3 stitch(vec2 st, vec4 igrid, vec2 colsrows, float randIndex, float intensity){

  	float rand = random(igrid.zw);
  	float stepper = step(intensity, randIndex);

  	//compute the pixelated uv which is define by the colsrows coordinate of the center of each cell normalized
  	vec2 stitchuv = (igrid.zw) / colsrows ;
  	stitchuv.x = st.x;

  	vec2 uv = st * stepper + stitchuv * (1.0 - stepper);

	return texture(texture, uv).rgb;
}


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);

	float ftime = animationTime(breakTime, speedTime);

	vec4 igrid 		= grid(uv, colsrows);
	float randIndex = random(igrid.zw);
	vec2 waveuv 	= waveUV(uv, colsrows, frequency, amplitude, ftime, randIndex, INVERTINTENSITY);
	igrid 			= grid(waveuv, colsrows);
	igrid			= subdivideGrid(igrid, ftime, subdivision);
	randIndex		= random(igrid.zw + ftime);

	vec3 cstitch	= stitch(uv, igrid, colsrows / subdivision, randIndex, intensity);

	fragColor = vec4(cstitch, 1.0);
}