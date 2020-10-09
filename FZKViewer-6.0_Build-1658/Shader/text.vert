#version 420 core

layout(location = 0) in vec3 position; 
layout(location = 1) in vec2 tex; 

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};

uniform mat4 textModel;
uniform bool useSmallText;
uniform mat4 coordinateSystemProj;
uniform mat4 tripodModel;
out vec2 TexCoords;

void main()
{

	if(useSmallText)
	gl_Position = coordinateSystemProj * tripodModel * textModel * vec4(position, 1.0);
	else
    gl_Position = vp * model * textModel * vec4(position, 1.0);
	
    TexCoords = tex;
}  