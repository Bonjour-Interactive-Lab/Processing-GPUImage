#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// Original shader by mrharicot
// https://www.shadertoy.com/view/4dfGDH
// Ported to Processing by Raphaël de Courville <twitter: @sableRaph>
// Update in order to use vertTexCoord attribute by BonjourLab

#define SIGMA 5.0
#define BSIGMA 0.1
#define MSIZE 5 //define the kerner size

uniform sampler2D texture;
uniform vec2 resolution;
in vec4 vertTexCoord;

out vec4 fragColor;

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
	vec2 uv = vertTexCoord.xy;
	vec2 screenuv = vertTexCoord.xy * resolution.xy;
	vec3 c = texture2D(texture, vertTexCoord.xy).rgb;
		
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
			vec2 iuv = (screenuv + vec2(float(i),float(j)) ) / resolution.xy ;
			cc = texture2D(texture, vec2(0.0, 0.0) + iuv).rgb;
			factor = normpdf3(cc-c, BSIGMA)*bZ*kernel[kSize+j]*kernel[kSize+i];
			Z += factor;
			final_colour += factor*cc;

		}
	}
	
	fragColor = vec4(final_colour/Z, 1.0);
}