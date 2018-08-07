#ifdef GL_ES
precision highp float;
precision highp vec4;
precision highp vec3;
precision highp vec2;
precision highp int;
#endif

const vec4 efactor = vec4(1.0, 255.0, 65025.0, 16581375.0);
const vec4 dfactor = vec4(1.0/1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
const float mask = 1.0/256.0;

uniform sampler2D texture;
uniform sampler2D posBuffer;
uniform sampler2D massBuffer;
uniform sampler2D maxVelBuffer;
uniform vec2 worldResolution;
uniform float minVel;
uniform float maxVel;
uniform float maxMass;
uniform float minMass;
uniform vec2 gravity = vec2(0.0, 0.1);
uniform vec2 wind = vec2(0.0, 0.0);
uniform vec2 mouse;
uniform float mouseSize;

in vec4 vertColor;
in vec4 vertTexCoord;

out vec4 fragColor;

vec2 encodeRGBA16(float v){
	vec2 rg = v * efactor.rg;
	rg.g = fract(rg.g);
	rg.r -= rg.g * mask;
	return vec2(rg);
}

vec4 encodeRGBA1616(vec2 xy){
	vec4 encodedData = vec4(encodeRGBA16(xy.x), encodeRGBA16(xy.y));
	encodedData.a = 1.0;
	return encodedData;
}

vec2 decodeRGBA16(vec4 rgba){
	return vec2(dot(rgba.rg, dfactor.rg), dot(rgba.ba, dfactor.rg));
}

float decodeRGBA32(vec4 rgba){
	return dot(rgba, dfactor.rgba);
}


void main() {
	vec4 velRGBA = texture(texture, vertTexCoord.xy);
	vec4 posRGBA = texture(posBuffer, vertTexCoord.xy);
	vec4 massRGBA = texture(massBuffer, vertTexCoord.xy);
	vec4 maxVelRGBA = texture(maxVelBuffer, vertTexCoord.xy);

	vec2 acc = vec2(0.0);
	float edgeVel = mix(minVel, maxVel, decodeRGBA32(maxVelRGBA));
	vec2 vel = (decodeRGBA16(velRGBA) * 2.0 - 1.0) * edgeVel; //we remap vel from  [0, 1] to [-1, 1] in order to have velocity in both side -x/+x -y/+y
	vec2 loc = decodeRGBA16(posRGBA) * worldResolution; //we remap the position from [0, 1] to [0, worldspace]	
	float mass = mix(minMass, maxMass, decodeRGBA32(massRGBA)); //we remap the mass from [0, 1] to [minMass, maxMass]

	//define friction
	float coeff = 0.35;
	vec2 friction = normalize(vel * -1.0) * coeff;

	//add forces
	acc += wind/mass;
	acc += (friction / mass);
	acc += gravity;

	//add acc to velocity
	vel += acc;
	vel = clamp(vel, -vec2(edgeVel), vec2(edgeVel)); //clamp velocity to max force

	//add vel to location
	loc += vel;

	//we compute the distance between the mouse and the particle in order to define if it bounce on it
	vec2 LtoM = mouse - loc;
	float d = length(LtoM);
	float edgeObstacle = step(mouseSize * 0.5, d) * 2.0 - 1.0;
	//We compute the reflect vector. By these we do not have a  straight line bounce
	// R = 2 * N * (N . L) -L
	vec2 N = normalize(LtoM * -1.0);
	vec2 I = vel; //incidence vector
	vec2 R = reflect(vel, N); //reflection algorithm
	//vec2 R = I - 2.0 * dot(N, I) * N; //reflection algorithm
	//we reduce the bounce factor
	R *= 0.15;

	//we define the bounce condition
	vel =  R * (1.0 - edgeObstacle) + vel * (edgeObstacle);

	//edge condition
	float edgeXL = 1.0 - step(0.0, loc.x);// if x < 0 : 1.0 else 0.0
	float edgeXR = step(worldResolution.x, loc.x);// if x > 1.0 : 1.0 else 0.0;
	float edgeX = (1.0 - (edgeXL + edgeXR)) * 2.0 - 1.0; // 0<x<1 : 0.0 else -1.0<1.0;
	float edgeYT = 1.0 - step(0.0, loc.y);// if x < 0 : 1.0 else 0.0
	float edgeYB = step(worldResolution.y, loc.y);// if x > 1.0 : 1.0 else 0.0;
	float edgeY = (1.0 - (edgeYT + edgeYB)) * 2.0 - 1.0; // 0<x<1 : 0.0 else -1.0<1.0;
	vel.x *= edgeX;
	vel.y *= edgeY;

	vel /= edgeVel; //we normalize velocity
	vel = (vel * 0.5) + 0.5; //reset it from[-1, 1] to [0.0, 1.0]
	vel = clamp(vel, vec2(0), vec2(1.0)); //we clamp the velocity between [0, 1] (this is a security)

	//we encode the new velocuty as RGBA1616
	vec4 newPosEncoded = vec4(encodeRGBA16(vel.x), encodeRGBA16(vel.y));

  	fragColor = newPosEncoded;
}