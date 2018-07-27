
const vec2 efactor = vec2(1.0, 255.0);
const vec2 dfactor = vec2(1.0/1.0, 1.0/255.0);
const float mask = 1.0/256.0;

uniform mat4 transform;
uniform vec4 viewport;
uniform mat4 projection;
uniform mat4 modelview;
uniform mat4 texMatrix;

//intrinsic matrix where xy = Principal point offset xy and zw = focal length xy
//see more at http://ksimek.github.io/2013/08/13/intrinsic/
uniform sampler2D dataTexture;
uniform vec2 resolution = vec2(1280, 720);
uniform vec2 dataTexResolution = vec2(1280, 720);

attribute vec4 position;
attribute vec4 color;
attribute vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;

float decodeRGBA16(vec2 rg){
  return dot(rg, dfactor.rg);
}

vec2 decodeRGBA16(vec4 rgba){
  return vec2(decodeRGBA16(rgba.rg), decodeRGBA16(rgba.ba));
}


void main(){
  //get the data into texture
  vec4 tex = texture2D(dataTexture, color.xy);
  //decode the data 
  vec2 pos = decodeRGBA16(tex) * resolution;
  //get the world position by a back-projecting the pixel value into the real world

	vec4 clip = projection * modelview * vec4(pos, 0.0, 1.0);
	gl_Position = clip + projection * vec4(offset.xy, 0, 0);

	vertColor = vec4(1.0);
  
}