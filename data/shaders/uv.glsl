#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 resolution;
uniform sampler2D texture;
in vec4 vertTexCoord;

out vec4 fragColor;

void main(){
	//vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec4 rgba = texture(texture, vertTexCoord.xy) * vec4(vertTexCoord.xy, 0.0, 1.0);
	fragColor = rgba;
}