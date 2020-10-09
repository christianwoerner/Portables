#version 150

in	vec4 vtx_position;

uniform mat4 MVP;
uniform mat4 MANIP;

void main(void)
{
     gl_Position = MVP * MANIP * vtx_position;
}
