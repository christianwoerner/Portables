#version 420 core


layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;

uniform mat4 rubberProj;
uniform bool measurementFinished;

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};

out vec4 Color;
void main(){

Color = color;

if(measurementFinished)
gl_Position =  vp * model * vec4(position,  1.0);
else
gl_Position =  rubberProj * vec4(position,  1.0);

}