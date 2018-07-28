#version 150
#ifdef GL_ES
precision highp float;
precision highp vec2;
precision highp vec3;
precision highp vec4;
precision highp int;
#endif


const vec2 efactor = vec2(1.0, 255.0);
const vec2 dfactor = vec2(1.0/1.0, 1.0/255.0);
const float mask = 1.0/256.0;

uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat4 transform;

uniform sampler2D dataTexture;
uniform vec2 resolution = vec2(1280.0, 720.0);
uniform vec3 size = vec3(1.0, 1.0, 1.0);

attribute vec4 vertex;
attribute vec4 color;
attribute vec4 uv;

out vec4 vertColor;

float decodeRGBA16(vec2 rg){
  return dot(rg, dfactor.rg);
}

vec2 decodeRGBA16(vec4 rgba){
  return vec2(decodeRGBA16(rgba.rg), decodeRGBA16(rgba.ba));
}

void main(){
  
  //get the data into texture
  vec4 tex = texture2D(dataTexture, uv.xy);
  //decode the data 
  vec2 normPosition = decodeRGBA16(tex);
  //get the world position by a back-projecting the pixel value into the real world
  vec2 pos = normPosition* resolution.xy;

  // Vertex in clip coordinates
  /*mat4 rotationMat;
  rotationMat[0].xyzw = vec4(1.0, 0.0, 0.0, 0.0);
  rotationMat[1].xyzw = vec4(0.0, 1.0, 0.0, 0.0);
  rotationMat[2].xyzw = vec4(0.0, 0.0, 1.0, 0.0);
  rotationMat[3].xyzw = vec4(0.0, 0.0, 0.0, 1.0);

  mat4 sizeMat;
  sizeMat[0].xyzw = vec4(size.x, 0.0, 0.0, 0.0);
  sizeMat[1].xyzw = vec4(0.0, size.y, 0.0, 0.0);
  sizeMat[2].xyzw = vec4(0.0, 0.0, size.z, 0.0);
  sizeMat[3].xyzw = vec4(0.0, 0.0, 0.0, 1.0);
*/
  gl_Position = transform * vec4(pos, 0.0, 1.0);
  vertColor = color;
}