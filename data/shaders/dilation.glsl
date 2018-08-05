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
	float CC = texture(texture, uv).r;
	float CT = texture(texture, uv + vec2( 0.0, -1.0) * texelSize).r;
	float RT = texture(texture, uv + vec2( 1.0, -1.0) * texelSize).r;
	float RC = texture(texture, uv + vec2( 1.0,  0.0) * texelSize).r;
	float RB = texture(texture, uv + vec2( 1.0,  1.0) * texelSize).r;
	float CB = texture(texture, uv + vec2( 0.0,  1.0) * texelSize).r;
	float LB = texture(texture, uv + vec2(-1.0,  1.0) * texelSize).r;
	float LC = texture(texture, uv + vec2(-1.0,  0.0) * texelSize).r;
	float LT = texture(texture, uv + vec2(-1.0, -1.0) * texelSize).r;

	//compare value
	float val = max(CC, CT);
		  val = max(val, RT);
		  val = max(val, RC);
		  val = max(val, RB);
		  val = max(val, CB);
		  val = max(val, LB);
		  val = max(val, LC);
		  val = max(val, LT);

	fragColor = vec4(vec3(val), 1.0);
}