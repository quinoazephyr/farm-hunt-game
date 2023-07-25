shader_type spatial;
render_mode unshaded;

uniform float invert_y = 0.0; // 0.0 or 1.0 
uniform float intensity = 1.0;
uniform float bottom_vert_pos_y = 0.0;
uniform float top_vert_pos_y = 1.0;
varying vec3 vert;

void vertex() {
	vert = VERTEX;
}

void fragment() {
	float is_invert = step(0.01, invert_y);
	float is_not_invert = 1.0 - is_invert;
	float height =
		clamp(((-is_invert + is_not_invert) * vert.y + bottom_vert_pos_y) / top_vert_pos_y * intensity, 
		0.0, 1.0);
	vec2 uv = (vert.xz -0.5) * 0.5 + 0.5;//normalize(UV - 0.5) * 0.5 + 0.5;
	ALBEDO = vec3(height * uv, 0.0);
}