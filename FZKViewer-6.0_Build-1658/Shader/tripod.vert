#version 420 core


layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;

uniform mat4 coordinateSystemProj;
uniform mat4 specialMatrix;
uniform mat4 tripodModel;

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

if(drawBigTripod)
gl_Position =  vp * model * vec4(position, 1.0);
else
gl_Position =  coordinateSystemProj * tripodModel *  vec4(position, 1.0);

}