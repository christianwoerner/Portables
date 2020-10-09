#version 420

layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;
layout(location = 2) in vec3 normal;
 
layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
    mat4 model;
    mat4 proj;
	mat4 view;
};

void main()
{
    gl_Position = vp * model * vec4(position, 1.0);
}
