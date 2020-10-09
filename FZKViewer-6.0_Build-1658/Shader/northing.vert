#version 420 core


layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;

uniform mat4 specialMatrix;

out vec4 colorOut;

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};

uniform bool drawBigTripod;
void main(){

colorOut = color;

gl_Position =  vp * model * specialMatrix * vec4(position, 1.0);


}