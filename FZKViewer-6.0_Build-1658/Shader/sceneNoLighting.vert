#version 420 core


layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;
layout(location = 2) in vec3 normal;

out vec4 colorFromFile;

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};

void main(){

colorFromFile = color;

gl_Position = vp * model *  vec4(position, 1.0);

}