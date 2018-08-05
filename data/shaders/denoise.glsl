#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


/**
 * Simple denoise algorithm based average neigbors and weight.
 */
#define EXP 0.5

uniform sampler2D texture;
uniform vec2 resolution;

in vec4 vertTexCoord;

out vec4 fragColor;

vec4 addAverageNeighbors(sampler2D texture, vec2 uv, vec2 ij, vec2 resolution, vec4 center){
	vec4 samplePix = texture(texture, uv + ij / resolution);
	//float weight = abs(1.0 - (ij.x + ij.y) * 0.25);
	float weight = 1.0 - abs(dot(samplePix.rgb - center.rgb, vec3(0.25)));
	weight = pow(weight, EXP);
	return vec4(samplePix.rgb * weight, weight);
}

void main() {
	vec2 uv = vertTexCoord.xy;
	vec4 center = texture(texture, uv);
	vec4 color = vec4(0.0);

	color += addAverageNeighbors(texture, uv, vec2(-1, -1), resolution, center);
	color += addAverageNeighbors(texture, uv, vec2( 0, -1), resolution, center);
	color += addAverageNeighbors(texture, uv, vec2( 1, -1), resolution, center);

	color += addAverageNeighbors(texture, uv, vec2(-1,  0), resolution, center);
	color += addAverageNeighbors(texture, uv, vec2( 0,  0), resolution, center);
	color += addAverageNeighbors(texture, uv, vec2( 1,  0), resolution, center);

	color += addAverageNeighbors(texture, uv, vec2(-1,  1), resolution, center);
	color += addAverageNeighbors(texture, uv, vec2( 0,  1), resolution, center);
	color += addAverageNeighbors(texture, uv, vec2( 1,  1), resolution, center);

	fragColor = vec4(color.rgb / color.a, 1.0);
}

