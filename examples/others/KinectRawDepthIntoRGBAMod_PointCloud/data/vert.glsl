
uniform mat4 transform;
uniform mat4 projection;
uniform mat4 modelview;

//intrinsic matrix where xy = Principal point offset xy and zw = focal length xy
//see more at http://ksimek.github.io/2013/08/13/intrinsic/
uniform vec4 DepthIntrinsic = vec4(259.31349, 197.22701, 361.2221, 361.85728);
uniform sampler2D dataTexture;
uniform int dataMax = 8000;
uniform vec2 resolution = vec2(512.0, 424.0);

attribute vec4 position;
attribute vec4 color;
attribute vec2 offset;

out vec4 vertColor;
out vec4 vertTexCoord;

float decodeRGBAMod(vec4 rgba, float edge){
  float divider = float(edge) / 256.0;
  float index = round(rgba.b * divider);

  return rgba.r * 255.0 + 255.0 * index;
}

vec3 computeWorldCoord(vec2 pixel, float depth){
  float x = (pixel.x - DepthIntrinsic.x) * depth / DepthIntrinsic.z;
  float y = (pixel.y - DepthIntrinsic.y) * depth / DepthIntrinsic.w;
  float z = -depth;

  return vec3(x, y, z);
}

void main(){
	//Define vertTexCoord
	vertTexCoord.xy = (position.xy / resolution.xy);

  	//get the data into texture
  	vec4 tex = texture2D(dataTexture, vertTexCoord.xy);
  	//decode the data 
  	float depth = decodeRGBAMod(tex, dataMax) / 8000.0;
  	//get the world position by a back-projecting the pixel value into the real world
  	vec3 wordlPos = computeWorldCoord(vertTexCoord.xy * resolution.xy, depth * 500.0);

	vec4 clip = projection * modelview * vec4(wordlPos, 1.0);
	gl_Position = clip + projection * vec4(offset.xy * depth, 0, 0);
	
	vertColor = vec4(vec3(1.0 - depth), 1.0);
}