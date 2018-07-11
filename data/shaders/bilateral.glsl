
// Original shader by mrharicot
// https://www.shadertoy.com/view/4dfGDH
// Ported to Processing by Raphaël de Courville <twitter: @sableRaph>


#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define SIGMA 2.0
#define BSIGMA 1.0
#define MSIZE 5

uniform sampler2D texture;
uniform vec2 resolution;

in vec4 vertTexCoord;

float normpdf(in float x, in float sigma)
{
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

float normpdf3(in vec3 v, in float sigma)
{
	return 0.39894*exp(-0.5*dot(v,v)/(sigma*sigma))/sigma;
}


void main(void)
{
	vec2 uv = vertTexCoord.xy;//gl_FragCoord.xy / resolution.xy;
	uv.y = 1.0 - uv.y;
	vec3 c = texture2D( texture, vertTexCoord.xy).rgb;
		
	//declare stuff
	const int kSize = (MSIZE-1)/2;
	float kernel[MSIZE];
	vec3 final_colour = vec3(0.0);
	
	//create the 1-D kernel
	float Z = 0.0;
	for (int j = 0; j <= kSize; ++j)
	{
		kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), SIGMA);
	}
	
	
	vec3 cc;
	float factor;
	float bZ = 1.0/normpdf(0.0, BSIGMA);
	//read out the texels
	for (int i=-kSize; i <= kSize; ++i)
	{
		for (int j=-kSize; j <= kSize; ++j)
		{
			vec2 iuv = ( gl_FragCoord.xy + vec2(float(i),float(j)) ) / resolution.xy ;
			iuv.y = 1.0 - iuv.y;
			cc = texture2D(texture, vec2(0.0, 0.0) + iuv).rgb;
			factor = normpdf3(cc-c, BSIGMA)*bZ*kernel[kSize+j]*kernel[kSize+i];
			Z += factor;
			final_colour += factor*cc;

		}
	}
	
	gl_FragColor = vec4(final_colour/Z, 1.0);

}