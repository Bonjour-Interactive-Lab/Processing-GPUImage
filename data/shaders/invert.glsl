#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

in vec4 vertTexCoord;
out vec4 fragColor;


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);

	fragColor = vec4(vec3(1.0 - tex.rgb), 1.0);
}