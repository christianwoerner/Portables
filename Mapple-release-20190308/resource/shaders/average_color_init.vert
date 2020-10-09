#version 150

in  vec3 vtx_position;	// vertex position
in	vec3 vtx_normal;	// vertex normal
in  vec3 vtx_color;		// vertex color

uniform vec3 default_color;
uniform bool per_vertex_color;

layout(std140) uniform Matrices {
	mat4 MV;
	mat4 invMV;
	mat4 PROJ;
	mat4 MVP;
	mat4 MANIP;
	mat3 NORMAL;
	mat4 SHADOW;
	bool clippingPlaneEnabled;
	bool crossSectionEnabled;
	vec4 clippingPlane0;
	vec4 clippingPlane1;
};

// the data to be sent to the fragment shader
out Data{
	vec3 color;
	vec3 normal;
	vec3 position;
} DataOut;


void main(void)
{
	vec4 new_position = MANIP * vec4(vtx_position, 1.0);

	if (per_vertex_color)
		DataOut.color = vtx_color;
	else
		DataOut.color = default_color;

	DataOut.normal = NORMAL * vtx_normal;
	DataOut.position = new_position.xyz;

	gl_Position = MVP * new_position;
}
