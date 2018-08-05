#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


/*
Based on Morgan McGuire implementation of a 3*3 median filter
http://casual-effects.com/research/McGuire2008Median/index.html
RGB filtering. Optimized with no loop iteration by Bonjour Lab
*/
uniform sampler2D texture;
uniform vec2 resolution;
in vec4 vertTexCoord;

out vec4 fragColor;

//median functions
#define order(a, b)					temp = a; a = min(a, b); b = max(temp, b);
#define order2(a, b)				order(pix[a], pix[b]);
#define orderMin3(a, b, c)			order2(a, b); order2(a, c);
#define orderMax3(a, b, c)			order2(b, c); order2(a, c);
#define order3(a, b, c)				orderMax3(a, b, c); order2(a, b);
#define order4(a, b, c, d)			order2(a, b); order2(c, d); order2(a, c); order2(b, d);
#define order5(a, b, c, d, e)		order2(a, b); order2(c, d); orderMin3(a, c, e); orderMax3(b, d, e);
#define order6(a, b, c, d, e, f)	order2(a, d); order2(b, e); order2(c, f); orderMin3(a, b, c); orderMax3(d, e, f);


void main(){
	vec2 uv = vertTexCoord.xy; 
	vec2 uvinc = vec2(1.0) / resolution.xy;

	vec3 pix[9];
	vec3 temp;

	pix[0] = texture(texture, uv + vec2(-1.0, -1.0) * uvinc).rgb;
	pix[1] = texture(texture, uv + vec2(0.0, -1.0)  * uvinc).rgb;
	pix[2] = texture(texture, uv + vec2(1.0, -1.0)  * uvinc).rgb;
	pix[3] = texture(texture, uv + vec2(-1.0, 0.0)  * uvinc).rgb;
	pix[4] = texture(texture, uv + vec2(.0, .0)     * uvinc).rgb;
	pix[5] = texture(texture, uv + vec2(1.0, .0)    * uvinc).rgb;
	pix[6] = texture(texture, uv + vec2(-1.0, 1.0)  * uvinc).rgb;
	pix[7] = texture(texture, uv + vec2(.0, 1.0)    * uvinc).rgb;
	pix[8] = texture(texture, uv + vec2(1.0, 1.0)   * uvinc).rgb;

	order6(0, 1, 2, 3, 4, 5);
	order5(1, 2, 3, 4, 6);
	order4(2, 3, 4, 7);
	order3(3, 4, 8);

	vec4 color = vec4(pix[4], 1.0);

	fragColor =  color;
}