uniform mat4 projectionMatrix;
uniform mat4 modelviewMatrix;
uniform mat4 texMatrix; //not bound
uniform mat3 normalMatrix; //not bound
 
uniform vec4 viewport;
uniform int perspective; 
uniform sampler2D dataTexture;
uniform vec2 dataResolution;
uniform float t;
 
attribute vec4 position;
attribute vec4 color;
attribute vec2 offset;
attribute vec2 texCoord;//not bound
attribute vec3 normal; //not bound
attribute vec4 test; //not bound

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
	vec2 uv = (test.xy / dataResolution.xy) * 2.0;

  	//vertTexCoord = texMatrix * vec4(test.xy, 1.0, 1.0);

	vec4 rgba = texture2D(dataTexture, uv * dataResolution + vec2(t, 0.0));

  	vec4 pos = modelviewMatrix * position;
  	vec4 clip = projectionMatrix * pos;

  	// Perspective ---
  	// convert from world to clip by multiplying with projection scaling factor
  	// invert Y, projections in Processing invert Y
  	vec2 perspScale = (projectionMatrix * vec4(1, -1, 0, 0)).xy;

  	// formula to convert from clip space (range -1..1) to screen space (range 0..[width or height])
  	// screen_p = (p.xy/p.w + <1,1>) * 0.5 * viewport.zw

  	// No Perspective ---
  	// multiply by W (to cancel out division by W later in the pipeline) and
  	// convert from screen to clip (derived from clip to screen above)
  	vec2 noPerspScale = clip.w / (0.5 * viewport.zw);

  	gl_Position.xy = clip.xy + offset.xy * mix(noPerspScale, perspScale, float(perspective > 0));
  	gl_Position.zw = clip.zw;
  
 	//vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
  	vertColor = vec4(test.xy, 0.0, 1.0);

}