#version 420

out vec4 frag_color;
in vec3 texcoord;

uniform samplerCube skybox;

void main(){

frag_color = texture(skybox, texcoord);

}