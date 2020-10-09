#version 150


// Liangliang: it is weired that computing normals in shader results in artifacts along the 
//			   edges (Perhaps this effect comes from the peeling?).
// Note: if you change here, you should also uncomment the following in the source code:
//		 "program->set_uniform("smooth_shading", smooth_shading);"
#define USE_PROVIDED_NORMALS


// the output of this shader
out vec4 fragOutput0;
out vec4 fragOutput1;

uniform sampler2D ColorTex0;
uniform sampler2D ColorTex1;

#ifndef USE_PROVIDED_NORMALS
uniform bool	smooth_shading;
#endif // !USE_PROVIDED_NORMALS

uniform float	Alpha;

layout(std140) uniform Lighting {
	vec3	wLightPos;
	vec3	eLightPos;
	vec3	wCamPos;
	vec3	ambient;		// in [0, 1], r==g==b;
	vec3	specular;		// in [0, 1], r==g==b;
	float	shininess;
};

in Data{
	vec3 color;
	vec3 normal;
	vec3 position;
} DataIn;


vec4 ShadeFragment()
{
	vec3 normal;
#ifdef USE_PROVIDED_NORMALS
	normal = normalize(DataIn.normal);
#else  // compute normals using dFdx and dFdy
	if (smooth_shading)
		normal = normalize(DataIn.normal);
	else {
		normal = normalize(cross(dFdx(DataIn.position), dFdy(DataIn.position)));
		if (dot(normal, DataIn.normal) < 0)
			normal = -normal;
	}
#endif 

	vec3 view_dir = normalize(wCamPos - DataIn.position);
	vec3 light_dir = normalize(wLightPos);

	// diffuse factor
	float df = abs(dot(light_dir, normal));				// light up both sides

	// specular factor
	vec3 half_vector = normalize(light_dir + view_dir);	// compute the half vector
	float sf = max(dot(half_vector, normal), 0.0);		// only the front side can have specular
	sf = pow(sf, shininess);

	return vec4(DataIn.color * df + specular * sf + ambient, Alpha);
}

void main(void)
{
	vec4 color = ShadeFragment();
	fragOutput0 = vec4(color.rgb * color.a, color.a);
	fragOutput1 = vec4(1.0);
}
