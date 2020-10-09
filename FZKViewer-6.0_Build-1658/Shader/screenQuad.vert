#version 410 core

in vec4 position;
in vec2 texcoord;

noperspective out vec2 Texcoord;
void main(){

Texcoord = texcoord; 

//Texcoord = vec2(texcoord.s, 1.0 - texcoord.t);

gl_Position = position;
}