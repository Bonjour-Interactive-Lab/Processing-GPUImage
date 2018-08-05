#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//based on https://fr.wikipedia.org/wiki/Filtre_de_Sobel

const float SOBELX[9] = float[](-1.0,  0.0,  1.0, 
								-2.0,  0.0,  2.0, 
								-1.0,  0.0,  1.0);
const float SOBELY[9] = float[](-1.0, -2.0, -1.0, 
					 			 0.0,  0.0,  0.0, 
					 			 1.0,  2.0,  1.0);

uniform sampler2D texture;
uniform vec2 resolution;
uniform float sobelxScale = 1.0;
uniform float sobelyScale = 1.0;

in vec4 vertTexCoord;
out vec4 fragColor;


void main(){
	vec2 uv = vertTexCoord.xy;
	vec4 tex = texture(texture, uv);
	vec2 uvinc = vec2(1.0) / resolution.xy;

	vec4 sobelh = texture(texture, uv + vec2(-1.0,  1.0) * uvinc) * sobelxScale * SOBELX[0] +
				  texture(texture, uv + vec2(-1.0,  0.0) * uvinc) * sobelxScale * SOBELX[3] +
				  texture(texture, uv + vec2(-1.0,  1.0) * uvinc) * sobelxScale * SOBELX[6] +
				  texture(texture, uv + vec2( 1.0, -1.0) * uvinc) * sobelxScale * SOBELX[2] +
				  texture(texture, uv + vec2( 1.0,  0.0) * uvinc) * sobelxScale * SOBELX[5] +
				  texture(texture, uv + vec2( 1.0,  1.0) * uvinc) * sobelxScale * SOBELX[8];

	vec4 sobelv = texture(texture, uv + vec2(-1.0,  1.0) * uvinc) * sobelyScale * SOBELY[0] +
				  texture(texture, uv + vec2(-1.0,  0.0) * uvinc) * sobelyScale * SOBELY[1] +
				  texture(texture, uv + vec2(-1.0,  1.0) * uvinc) * sobelyScale * SOBELY[2] +
				  texture(texture, uv + vec2( 1.0, -1.0) * uvinc) * sobelyScale * SOBELY[6] +
				  texture(texture, uv + vec2( 1.0,  0.0) * uvinc) * sobelyScale * SOBELY[7] +
				  texture(texture, uv + vec2( 1.0,  1.0) * uvinc) * sobelyScale * SOBELY[8];

	vec4 sobelEdge = sqrt(sobelh * sobelh + sobelv * sobelv);


	fragColor = vec4(sobelEdge.rgb, 1.0);
}