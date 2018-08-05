#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float gamma = 2.2;
uniform sampler2D texture;
in vec4 vertTexCoord;
out vec4 fragColor;

/*-------------------- GAMMA CORRECTION ---------------------------*/
vec3 toLinear(vec3 rgb){
  return pow(rgb, vec3(gamma));
}

vec4 toLinear(vec4 rgba){
  return vec4(toLinear(rgba.rgb), rgba.a);
}

vec3 toGamma(vec3 rgb){
  return pow(rgb, vec3(1.0/gamma));
}

vec4 toGamma(vec4 rgba){
  return vec4(toGamma(rgba.rgb), rgba.a);
}

void main(){
	vec2 uv = vertTexCoord.xy; 
	vec4 tex = texture(texture, uv);
	vec4 color = toGamma(tex);
	

	fragColor =  color;
}