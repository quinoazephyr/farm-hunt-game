shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount: hint_range(0.0, 5.0);
uniform float brightness = 0.15;
uniform float contrast = 1.2;
uniform float saturation = 1.5;

mat4 brightnessMatrix(float t_brightness) {
	return mat4(vec4(1, 0, 0, 0), 
			vec4(0, 1, 0, 0), 
			vec4(0, 0, 1, 0), 
			vec4(t_brightness, t_brightness, t_brightness, 1));
}

mat4 contrastMatrix(float t_contrast) {
	float t = (1.0 - t_contrast) / 2.0;
	return mat4(vec4(t_contrast, 0, 0, 0), 
			vec4(0, t_contrast, 0, 0), 
			vec4(0, 0, t_contrast, 0), 
			vec4(t, t, t, 1));
}

mat4 saturationMatrix(float t_saturation) {
	vec3 luminance = vec3(0.3086, 0.6094, 0.0820);
	float oneMinusSat = 1.0 - t_saturation;
	
	vec3 red = vec3(luminance.x * oneMinusSat);
	red += vec3(t_saturation, 0, 0);
	vec3 green = vec3(luminance.y * oneMinusSat);
	green += vec3(0, t_saturation, 0);
	vec3 blue = vec3(luminance.z * oneMinusSat);
	blue += vec3(0, 0, saturation);
    
	return mat4(vec4(red, 0), vec4(green, 0), vec4(blue, 0), vec4(0, 0, 0, 1));
}

void fragment() {
	vec3 color = textureLod(screen_texture, SCREEN_UV, blur_amount).rgb;
	COLOR = brightnessMatrix(brightness) * contrastMatrix(contrast) * 
			saturationMatrix(saturation) * vec4(color, 1.0);
}
