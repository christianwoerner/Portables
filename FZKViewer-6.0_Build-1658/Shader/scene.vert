#version 420 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;
layout(location = 2) in vec3 normal;
layout(location = 3) in vec2 texcoord;

out vec4 colorFromFile;
out vec3 Normal;
out vec3 FragPos;
out vec2 texcoord_out;
out vec4 FragPosLightSpace0;
out vec4 FragPosLightSpace1;
out vec4 FragPosLightSpace2;
out vec4 VertexPosition;

layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
	mat4 model;
    mat4 proj;
	mat4 view;
};

uniform mat3 normalMat;
uniform mat4 lightSpaceMatrix0;
uniform mat4 lightSpaceMatrix1;
uniform mat4 lightSpaceMatrix2;

void main(){

texcoord_out = texcoord;
colorFromFile = color;
VertexPosition = vec4(position, 1.0);
//Normal = mat3(transpose(inverse(model))) * normal; 
Normal = normalMat * normal;
FragPos = vec3(model * vec4(position, 1.0));
//FragPosLightSpace = lightSpaceMatrix  *  vec4(FragPos, 1.0);
FragPosLightSpace0 = lightSpaceMatrix0 * vec4(FragPos, 1.0);
FragPosLightSpace1 = lightSpaceMatrix1 * vec4(FragPos, 1.0);
FragPosLightSpace2 = lightSpaceMatrix2 * vec4(FragPos, 1.0);

gl_Position = vp * model * vec4(position, 1.0);

}