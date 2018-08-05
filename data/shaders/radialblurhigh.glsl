#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


uniform sampler2D texture;
uniform vec2 resolution;
uniform vec2 blurOrigin = vec2(0.5);
uniform float blurSize = 0.1;

in vec4 vertTexCoord;
out vec4 fragColor;

#define scale(i)		scale = 1.0 - (blurSize * distToCenter) * (float(i) / float(octave - 1))
#define blur(i)			scale(i); blur += vec4(texture(texture, uv * scale + blurOrigin).rgb, 1.0)

vec4 radialBlur(vec2 uv, vec2 texelSize, float blurSize, vec2 blurOrigin)
{
	vec4 focus = texture(texture, blurOrigin);
	vec4 blur = vec4(0.0, 0.0, 0.0, 0.0);
	float scale;
	int octave = 20;

	float distToCenter = length(uv - blurOrigin);

	uv += texelSize * 0.5 - blurOrigin;

	blur(1);
	blur(2);
	blur(3);
	blur(4);
	blur(5);
	blur(6);
	blur(7);
	blur(8);
	blur(9);
	blur(10);
	blur(11);
	blur(12);
	blur(13);
	blur(14);
	blur(15);
	blur(16);
	blur(17);
	blur(18);
	blur(19);
	blur(20);

	return blur / 20;
}

void main(){
	vec2 texelSize =  vec2(1.0)/resolution;
	vec4 rd = radialBlur(vertTexCoord.xy, texelSize, blurSize, blurOrigin);
	fragColor = rd;
}