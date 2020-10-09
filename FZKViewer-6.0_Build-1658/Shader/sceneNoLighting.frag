#version 330 core

in vec4 colorFromFile;

out vec4 FragColor;

uniform vec4 colorFromEntity;

void main(){
	vec4 objectColor;
    if(colorFromEntity.x != -1){
    objectColor = colorFromEntity;
    }
    else{
    objectColor = colorFromFile;
    } 
    
    FragColor = objectColor;

}
