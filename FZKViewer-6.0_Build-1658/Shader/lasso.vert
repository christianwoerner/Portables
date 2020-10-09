#version 420 core


layout(location = 0) in vec2 position;

uniform mat4 lassoProj;


layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};

void main(){



gl_Position =  lassoProj * vec4(position, 1.0,  1.0);

}