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