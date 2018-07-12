#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


#define offset 43758.5453123
uniform sampler2D texture;
uniform vec2 resolution;
uniform vec2 blurOrigin = vec2(0.5);
uniform float blurSize = 0.1;
uniform int octave = 4;
uniform float angle = 3.14159265359 / 200.0;

in vec4 vertTexCoord;
out vec4 fragColor;


mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

vec4 radialBlur(int octave, vec2 uv, vec2 texelSize, float blurSize, vec2 blurOrigin, float angle)
{
	vec4 focus = texture2D(texture, blurOrigin);
	vec4 blur = vec4(0.0, 0.0, 0.0, 0.0);

	float distToCenter = length(uv - blurOrigin);

	uv += texelSize * 0.5 - blurOrigin;

	for (int i = 0; i < octave; i++) 
	{
	  float scale = 1.0 - (blurSize * distToCenter) * (float(i) / float(octave - 1));
	  vec2 uvRed   = rotate2d( angle * distToCenter) * uv;
	  vec2 uvGreen = uv;
	  vec2 uvRBlue = rotate2d(-angle * distToCenter) * uv;
	  blur += vec4( texture2D(texture, uvRed   * scale + blurOrigin).r,
	  				texture2D(texture, uvGreen * scale + blurOrigin).g,
	  				texture2D(texture, uvRBlue * scale + blurOrigin).b,
	  				1.0);
	}

	return blur / float(octave);
}

void main(){
	vec2 texelSize =  vec2(1.0)/resolution;
	vec4 rd = radialBlur(octave, vertTexCoord.xy, texelSize, blurSize, blurOrigin, angle);
	fragColor = rd;
}