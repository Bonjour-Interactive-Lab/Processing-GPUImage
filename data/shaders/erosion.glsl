#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;

in vec4 vertTexCoord;
out vec4 fragColor;


void main(){
	vec2 uv = vertTexCoord.xy;
	vec2 texelSize = vec2(1.0) / resolution;

	//define neighbors
	float CC = texture2D(texture, uv).r;
	float CT = texture2D(texture, uv + vec2( 0.0, -1.0) * texelSize).r;
	float RT = texture2D(texture, uv + vec2( 1.0, -1.0) * texelSize).r;
	float RC = texture2D(texture, uv + vec2( 1.0,  0.0) * texelSize).r;
	float RB = texture2D(texture, uv + vec2( 1.0,  1.0) * texelSize).r;
	float CB = texture2D(texture, uv + vec2( 0.0,  1.0) * texelSize).r;
	float LB = texture2D(texture, uv + vec2(-1.0,  1.0) * texelSize).r;
	float LC = texture2D(texture, uv + vec2(-1.0,  0.0) * texelSize).r;
	float LT = texture2D(texture, uv + vec2(-1.0, -1.0) * texelSize).r;

	//compare value
	float val = min(CC, CT);
		  val = min(val, RT);
		  val = min(val, RC);
		  val = min(val, RB);
		  val = min(val, CB);
		  val = min(val, LB);
		  val = min(val, LC);
		  val = min(val, LT);

	fragColor = vec4(vec3(val), 1.0);
}