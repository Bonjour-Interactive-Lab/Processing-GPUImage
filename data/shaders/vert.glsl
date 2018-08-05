uniform mat4 transform;
uniform mat4 texMatrix;
in vec4 vertex;
in vec2 texCoord;
out vec4 vertTexCoord;

void main() {
    vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
    gl_Position = transform * vertex;
}