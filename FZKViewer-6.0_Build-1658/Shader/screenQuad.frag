#version 410 core

out vec4 color;
noperspective in vec2 Texcoord;

uniform sampler2D tex;

void main(){


//color = texture(tex, Texcoord);

float depthValue = texture(tex, Texcoord).r;
color = vec4(vec3(depthValue), 1.0);

}