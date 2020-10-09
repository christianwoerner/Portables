#version 330 core
layout(location = 0) in vec3 position; 
layout(location = 1) in vec2 tex; 

out vec2 TexCoords;

uniform mat4 projection;

void main()
{
    gl_Position = projection * vec4(position.xy, 0.0, 1.0);
	//gl_Position = vec4(position.xy, 0.0, 1.0);
    TexCoords = tex;
}  
