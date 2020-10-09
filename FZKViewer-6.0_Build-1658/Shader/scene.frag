#version 330 core

in vec4 colorFromFile;
in vec3 Normal;
in vec3 FragPos;
in vec2 texcoord_out;
in vec4 FragPosLightSpace0;
in vec4 FragPosLightSpace1;
in vec4 FragPosLightSpace2;
in vec4 VertexPosition;
out vec4 FragColor;

uniform vec4 colorFromEntity;

uniform sampler2D shadowMap0;
uniform sampler2D shadowMap1;
uniform sampler2D shadowMap2;

uniform sampler2D textureSampler;
uniform bool useTexture;
uniform bool isText;
uniform bool useShadowMapping;

uniform vec3 viewPos;

uniform bool noLighting;

//fog values

uniform bool useFog;
uniform float fogStart;
uniform float fogEnd;
uniform vec4 fogColor;

struct DirLight {
    vec3 direction;
	float brightness;
	bool useShadow;

};  
struct PointLight {    
    vec3 position;
   
    float constant;
    float linear;
    float quadratic;  
};  

struct LightColor {
vec4 ambient;
vec4 diffuse;
vec4 specular;
};


struct SpotLight {
    vec3  position;
    vec3  direction;
    float cutOff;
};

uniform DirLight dirLights[8];
uniform PointLight pointLights[8];
uniform LightColor lightColors[8];
uniform SpotLight spotLights[8];

vec4 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir, LightColor color, int index);  
vec4 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir, LightColor color);
vec4 CalcSpotLight(SpotLight light, PointLight plight, vec3 normal, vec3 fragPos, vec3 viewDir, LightColor color);
float ShadowCalculation(vec4 fragPosLightSpace);
float getFogFactor(float d);

vec4 objectColor;

float getFogFactor(float d)
{
     float FogMax = fogEnd;
     float FogMin = fogStart;

    if (d>=FogMax) return 1;
    if (d<=FogMin) return 0;

    return 1 - (FogMax - d) / (FogMax - FogMin);
}

float ShadowCalculation(int index)
{


vec3 projCoords = vec3(0.0, 0.0, 0.0); 
float closestDepth = 0.0f;


if(index == 0){
projCoords = FragPosLightSpace0.xyz / FragPosLightSpace0.w;
projCoords = projCoords * 0.5 + 0.5;
closestDepth = texture(shadowMap0, projCoords.xy).r;
}
if(index == 1){
projCoords = FragPosLightSpace1.xyz / FragPosLightSpace1.w;
projCoords = projCoords * 0.5 + 0.5;
closestDepth = texture(shadowMap1, projCoords.xy).r;
}
if(index == 2){
projCoords = FragPosLightSpace2.xyz / FragPosLightSpace2.w;
projCoords = projCoords * 0.5 + 0.5;
closestDepth = texture(shadowMap2, projCoords.xy).r;
}
   
   float currentDepth = projCoords.z;
   float shadow = currentDepth - 0.005 > closestDepth ? 1.0 : 0.0;
   return shadow;
}


vec4 CalcSpotLight(SpotLight light, PointLight plight, vec3 normal, vec3 fragPos, vec3 viewDir, LightColor color){

vec3 lightDir = normalize(light.position - fragPos);


float theta = dot(lightDir, normalize(-light.direction));
    
if(theta > light.cutOff) 
{       
    float diff = max(dot(normal, lightDir), 0.0);
    
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    
    float distance    = length(light.position - fragPos);
    float attenuation = plight.constant + plight.linear * distance + 
  			     plight.quadratic * (distance * distance);
    if( attenuation != 0.0){
    attenuation = 1.0/ attenuation;
             }
  
    
    vec4 ambient  = color.ambient  * objectColor;
    vec4 diffuse  = color.diffuse  * diff * objectColor;
    vec4 specular = color.specular * spec;
    ambient  *= attenuation;
    diffuse  *= attenuation;
    specular *= attenuation;

//if(useShadowMapping){
	//float shadow = ShadowCalculation(FragPosLightSpace);       
    //return (ambient + (1.0 - shadow) * (diffuse + specular));
	//}
	//else
    return (ambient + diffuse + specular);
}
else{
  return color.ambient * objectColor;
  }

}


vec4 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir, LightColor color, int index)
{

   
    //umgedreht statt eigentlich -light.direction
    vec3 lightDir = normalize(light.direction);
    
    float diff = max(dot(normal, lightDir), 0.0);
    
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    
    vec4 ambient  = color.ambient  * objectColor;
    vec4 diffuse  = color.diffuse  * diff * objectColor;
    vec4 specular = color.specular * spec;
	
	if(light.useShadow){
	float shadow = ShadowCalculation(index);       
    return (ambient + (1.0 - shadow) * (diffuse + specular))*light.brightness/10;
	}
	else
	return (ambient + diffuse + specular)*light.brightness/10;
}  

vec4 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir, LightColor color)
{
    

    vec3 lightDir = normalize(light.position - fragPos);
    
    float diff = max(dot(normal, lightDir), 0.0);
    
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    
    float distance    = length(light.position - fragPos);
    float attenuation = light.constant + light.linear * distance + 
  			     light.quadratic * (distance * distance);
    if( attenuation != 0.0){
    attenuation = 1.0/ attenuation;
             }
  
    
    vec4 ambient  = color.ambient  * objectColor;
    vec4 diffuse  = color.diffuse  * diff * objectColor;
    vec4 specular = color.specular * spec ;
    ambient  *= attenuation;
    diffuse  *= attenuation;
    specular *= attenuation;

	//if(useShadowMapping){
    //float shadow = ShadowCalculation(FragPosLightSpace);       
    //return (ambient + (1.0 - shadow) * (diffuse + specular));
	//}
	//else
	return (ambient + diffuse + specular);
       
} 

void main(){
	
    if(colorFromEntity.x != -1){
    objectColor = colorFromEntity;
    }
    else{
    objectColor = colorFromFile;
    }
    
	if(isText){
	vec4 sampled = vec4(1.0, 1.0, 1.0, texture(textureSampler, texcoord_out).r);
	FragColor = objectColor * sampled;
	if(objectColor.a == 0)
	FragColor = vec4(0.0f, 1.0f, 1.0f, 1.0f) * sampled;
	return;
	}
	
	if(noLighting){
	FragColor = objectColor;
	return;
	}
	
	
    vec3 norm = normalize(Normal);
    vec3 viewDir = normalize(viewPos - FragPos);

    vec4 result = vec4(0.0, 0.0, 0.0, 0.0);

    for(int i = 0; i < 8; i++){
    result += CalcDirLight(dirLights[i], norm, viewDir, lightColors[i], i);
    result += CalcPointLight(pointLights[i], norm, FragPos, viewDir, lightColors[i]); 
    result += CalcSpotLight(spotLights[i], pointLights[i], norm, FragPos, viewDir, lightColors[i]);
    }   
    
    result.a = objectColor.a;
	
	if(useTexture)
	FragColor = texture(textureSampler, texcoord_out);
	else
    FragColor = result;
	
	
	//Fog
	if(useFog){
	
	 //float d = distance(vec4(viewPos,1.0f), VertexPosition);
	 float d = gl_FragCoord.z;
    float alpha = getFogFactor(d);
	FragColor = mix(FragColor, fogColor, alpha);
	
	}
	
	//FragColor = vec4(FragColor.x/1.5f,FragColor.y/1.5f,FragColor.z/1.5f,FragColor.w);
	

}
