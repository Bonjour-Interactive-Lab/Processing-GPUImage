#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//based on https://www.objc.io/issues/21-camera-and-photos/gpu-accelerated-machine-vision/
uniform sampler2D texture;
uniform vec2 resolution;
uniform float lowerThreshold = 0.8;

in vec4 vertTexCoord;
out vec4 fragColor;


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);
	vec2 uvinc = vec2(1.0) / resolution.xy;

	vec3 curGradientDir = texture(texture, uv).rgb;
	vec2 gradientDirection = ((curGradientDir.gb * 2.0) - 1.0) * uvinc;

    float firstSampledGradientMagnitude = texture(texture, uv + gradientDirection).r;
    float secondSampledGradientMagnitude = texture(texture, uv - gradientDirection).r;

    float multiplier = step(firstSampledGradientMagnitude, curGradientDir.r);
    multiplier = multiplier * step(secondSampledGradientMagnitude, curGradientDir.r);

    float thresholdCompliance = smoothstep(lowerThreshold, lowerThreshold + 0.01, curGradientDir.r);
    multiplier = multiplier * thresholdCompliance;

	fragColor = vec4(vec3(multiplier), 1.0);
}