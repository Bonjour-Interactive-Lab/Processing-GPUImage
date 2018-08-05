#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;
uniform vec2 blurOrigin = vec2(0.5);
uniform float blurSize = 0.1;
uniform int octave = 4;

in vec4 vertTexCoord;
out vec4 fragColor;


vec4 radialBlur(int octave, vec2 uv, vec2 texelSize, float blurSize, vec2 blurOrigin)
{
	vec4 focus = texture(texture, blurOrigin);
	vec4 blur = vec4(0.0, 0.0, 0.0, 0.0);

	float distToCenter = length(uv - blurOrigin);

	uv += texelSize * 0.5 - blurOrigin;

	for (int i = 0; i < octave; i++) 
	{
	  float scale = 1.0 - (blurSize * distToCenter) * (float(i) / float(octave - 1));
	  blur += vec4( texture(texture, uv   * scale + blurOrigin).rgb, 1.0);
	}

	return blur / float(octave);
}

void main(){
	vec2 texelSize =  vec2(1.0)/resolution;
	vec4 rd = radialBlur(octave, vertTexCoord.xy, texelSize, blurSize, blurOrigin);
	fragColor = rd;
}