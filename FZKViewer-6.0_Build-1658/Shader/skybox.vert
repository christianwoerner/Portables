#version 420 

in vec3 position;

out vec3 texcoord;

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
    mat4 model;
    mat4 proj;
	mat4 view;
};
uniform mat4 mat;

void main(){

texcoord = position;

mat4 view_t = mat4(mat3(vp));


gl_Position = mat * vec4(position, 1.0);
}