#version 420 

in vec3 position;


layout(std140, binding = 0) uniform GlobalMatrices { 
    mat4 vp;
    mat4 model;
    mat4 proj;
	mat4 view;
};
uniform mat4 lightSpaceMatrix;

void main(){

//gl_Position =  lightSpaceMatrix * model *  vec4(position, 1.0);
gl_Position =  lightSpaceMatrix * model * vec4(position.x,position.y ,position.z, 1.0);
}