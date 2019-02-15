//blend sources : http://wiki.polycount.com/wiki/Blending_functions

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;
uniform int searchDistance;

in vec4 vertTexCoord;
out vec4 fragColor;


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);

	vec2 texel = vec2(1.0) / resolution;

	float hypothenuse = sqrt(resolution.x * resolution.x + resolution.y * resolution.y);
	float distance = hypothenuse;

	//the main idea is to take the neighbors of a pixel
	//If this neighbors is whit we compute the distance between the pixel and the neighbors

    for (int i = -searchDistance; i<searchDistance; i ++) {
    	for (int j = -searchDistance; j<searchDistance; j ++) {

    		float fx = uv.x + texel.x * float(i);
			float fy = uv.y + texel.y * float(j);

    		vec4 neighbors = texture(texture, vec2(fx, fy));
    		if(neighbors.r == 1.0){
    			float xd = (uv.x - fx) * resolution.x;
            	float yd = (uv.y - fy) * resolution.y;
            	float d = sqrt(xd * xd + yd * yd);
            	if (abs(d) < distance) {
              		distance = d;
            	}
    		}
       }
    }

    distance = distance / searchDistance;
    distance = clamp(distance, 0.0, 1.0);

	vec3 sdf = vec3(distance);

    fragColor = vec4(sdf, 1.0);
}