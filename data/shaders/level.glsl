#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec3 minInput  = vec3(0.0);
uniform vec3 maxInput  = vec3(1.0);
uniform vec3 minOutput = vec3(0.0);
uniform vec3 maxOutput = vec3(1.0);
uniform vec3 gamma     = vec3(1.0);

in vec4 vertTexCoord;
out vec4 fragColor;

#define gammaCorrection(color, gamma)											pow(color, vec3(1.0) / gamma)
#define levelsControlInputRange(color, minInput, maxInput)						min(max(color - minInput, vec3(0.0)) / (maxInput - minInput), vec3(1.0))
#define levelsControlInput(color, minInput, gamma, maxInput)					gammaCorrection(levelsControlInputRange(color, minInput, maxInput), gamma)
#define levelsControlOutputRange(color, minOutput, maxOutput) 					mix(minOutput, maxOutput, color)
#define levelsControl(color, minInput, gamma, maxInput, minOutput, maxOutput) 	levelsControlOutputRange(levelsControlInput(color, minInput, gamma, maxInput), minOutput, maxOutput)

void main()
{
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture2D(texture, uv);

	tex.rgb = levelsControl(tex.rgb, minInput, gamma, maxInput, minOutput, maxOutput);


   	fragColor = tex;
}

