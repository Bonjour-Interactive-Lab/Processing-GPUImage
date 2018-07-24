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
	vec3 CC = texture2D(texture, uv).rgb;
	vec3 CT = texture2D(texture, uv + vec2( 0.0, -1.0) * texelSize).rgb;
	vec3 RT = texture2D(texture, uv + vec2( 1.0, -1.0) * texelSize).rgb;
	vec3 RC = texture2D(texture, uv + vec2( 1.0,  0.0) * texelSize).rgb;
	vec3 RB = texture2D(texture, uv + vec2( 1.0,  1.0) * texelSize).rgb;
	vec3 CB = texture2D(texture, uv + vec2( 0.0,  1.0) * texelSize).rgb;
	vec3 LB = texture2D(texture, uv + vec2(-1.0,  1.0) * texelSize).rgb;
	vec3 LC = texture2D(texture, uv + vec2(-1.0,  0.0) * texelSize).rgb;
	vec3 LT = texture2D(texture, uv + vec2(-1.0, -1.0) * texelSize).rgb;

	//compare value
	vec3 val = min(CC, CT);
		 val = min(val, RT);
		 val = min(val, RC);
		 val = min(val, RB);
		 val = min(val, CB);
		 val = min(val, LB);
		 val = min(val, LC);
		 val = min(val, LT);

	fragColor = vec4(val, 1.0);
}