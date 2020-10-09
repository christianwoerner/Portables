#version 420 core


layout(location = 0) in vec3 position;
layout(location = 1) in vec2 texcoord;

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};


out vec2 Texcoord;

uniform mat4 matrix;

void main(){

Texcoord = texcoord; 
gl_Position = vp * matrix * vec4(position.xyz, 1.0);

}