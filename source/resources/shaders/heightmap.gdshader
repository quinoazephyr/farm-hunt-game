shader_type spatial;
render_mode unshaded;

uniform float bottom_vert_pos_y = 0.0;
uniform float top_vert_pos_y = 1.0;
varying vec3 vert;

void vertex() {
	vert = VERTEX;
}

void fragment() {
	float height =
		clamp((vert.y + abs(bottom_vert_pos_y)) / (top_vert_pos_y + abs(bottom_vert_pos_y)), 
		0.0, 1.0);
	ALBEDO = vec3(height);
}