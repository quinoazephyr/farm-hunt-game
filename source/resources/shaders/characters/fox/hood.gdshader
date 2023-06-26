shader_type spatial;

uniform sampler2D diffuseTexture;
uniform float rimLightPower = 0.5;
uniform vec4 rimColor : source_color;

void fragment() {
	vec4 diffuseColor = texture(diffuseTexture, UV);
	
	vec3 eye = normalize(-VERTEX.xyz);
	float rimLightIntensity = dot(eye, NORMAL);
	rimLightIntensity = 1.0 - rimLightIntensity;
	rimLightIntensity = max(0.0, rimLightIntensity);
	rimLightIntensity = pow(rimLightIntensity, rimLightPower);
	rimLightIntensity = smoothstep(0.3, 0.4, rimLightIntensity);
	vec4 rimLight = rimLightIntensity * rimColor;
	rimLight.a = rimColor.a;
	
	vec4 outputColor = vec4(0.0);
	outputColor.a = diffuseColor.a;
	outputColor.rgb = rimColor.rgb + rimLight.rgb;
}
