vec4 alpha_blend(vec4 top, vec4 bottom)
{
	vec3 color = (top.rgb * top.a) + (bottom.rgb * (1.0 - top.a));
	float alpha = top.a + bottom.a * (1.0 - top.a);
	return vec4(color, alpha);
}

vec3 rotate_about_axis(vec3 point, vec3 axis, float angle) {
	return point * cos(angle) + 
		cross(axis, point) * sin(angle) + 
		axis * dot(axis, point) * (1.0 - cos(angle));
}

mat4 brightness_matrix(float t_brightness) {
	return mat4(vec4(1, 0, 0, 0), 
			vec4(0, 1, 0, 0), 
			vec4(0, 0, 1, 0), 
			vec4(t_brightness, t_brightness, t_brightness, 1));
}

mat4 contrast_matrix(float t_contrast) {
	float t = (1.0 - t_contrast) / 2.0;
	return mat4(vec4(t_contrast, 0, 0, 0), 
			vec4(0, t_contrast, 0, 0), 
			vec4(0, 0, t_contrast, 0), 
			vec4(t, t, t, 1));
}

mat4 saturation_matrix(float t_saturation) {
	vec3 luminance = vec3(0.3086, 0.6094, 0.0820);
	float oneMinusSat = 1.0 - t_saturation;
	
	vec3 red = vec3(luminance.x * oneMinusSat);
	red += vec3(t_saturation, 0, 0);
	vec3 green = vec3(luminance.y * oneMinusSat);
	green += vec3(0, t_saturation, 0);
	vec3 blue = vec3(luminance.z * oneMinusSat);
	blue += vec3(0, 0, t_saturation);
    
	return mat4(vec4(red, 0), vec4(green, 0), vec4(blue, 0), vec4(0, 0, 0, 1));
}