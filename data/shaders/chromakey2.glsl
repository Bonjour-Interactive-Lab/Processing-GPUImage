#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
#define PI 3.14159265359
uniform sampler2D texture;
uniform sampler2D base;
uniform float threshold = 0.5;
uniform float curveThreshold = 0.5;
uniform vec3 keyColor;
uniform int srci = 0;
uniform int basei = 0;

in vec4 vertTexCoord;
out vec4 fragColor;

vec3 rgb2hsv(vec3 rgb)
{
	float Cmax = max(rgb.r, max(rgb.g, rgb.b));
	float Cmin = min(rgb.r, min(rgb.g, rgb.b));
    float delta = Cmax - Cmin;

	vec3 hsv = vec3(0., 0., Cmax);
	
	if (Cmax > Cmin)
	{
		hsv.y = delta / Cmax;

		if (rgb.r == Cmax)
			hsv.x = (rgb.g - rgb.b) / delta;
		else
		{
			if (rgb.g == Cmax)
				hsv.x = 2. + (rgb.b - rgb.r) / delta;
			else
				hsv.x = 4. + (rgb.r - rgb.g) / delta;
		}
		hsv.x = fract(hsv.x / 6.);
	}
	return hsv;
}

float chromaKey(vec3 color, vec3 keycolor)
{
	vec3 weights = vec3(4.f, 1.f, 2.f);
    
    vec3 src = rgb2hsv(color);
    vec3 key = rgb2hsv(keycolor);
    
    return length(weights * (key - src));
}

vec3 changeSaturation(vec3 color, float saturation)
{
	float luma = dot(vec3(0.213, 0.715, 0.072) * color, vec3(1.));
	return mix(vec3(luma), color, saturation);
}

void main(){
	vec2 uv = vertTexCoord.xy; 
	vec2 iuv = vec2(uv.x, 1.0 - uv.y);

	vec3 tex = texture2D(texture, uv * (1 - basei) + iuv * basei).rgb;
	vec3 texBase = texture2D(base, uv * (1 - srci) + iuv * srci).rgb;
	float ckey = smoothstep(0.0, 1.0, chromaKey(tex, keyColor));
	float inc = smoothstep(threshold, 1.0, ckey);
	/*
	float 	curveinc1 = 1.0 - pow(cos(PI * inc / 2.0), curveThreshold);
	float	curveinc2 = pow(abs(inc), curveThreshold); 
	float 	curveinc3 = pow(abs(sin(PI * inc / 2.0)), curveThreshold);
	float 	curveinc4 = 1.0 - pow(min(cos(PI * inc / 2.0), 1.0 - abs(inc)), curveThreshold);
	*/
	vec4 finalColor= mix(vec4(texBase, 1.0), vec4(tex, 1.0), inc);

	fragColor =  finalColor;
}

 