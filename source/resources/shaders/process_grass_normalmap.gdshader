shader_type canvas_item;

uniform sampler2D input_map;

uniform float normal_strength = 10.0;

void fragment() {
	vec3 e = vec3(1.0/512.0, -1.0/512.0, 0.0);
	vec2 rv = vec2(0.0);
	
	rv += vec2(2.0, 0.0) * texture(input_map, UV+e.xz).r;
	rv += vec2(-2.0, 0.0) * texture(input_map, UV-e.xz).r;
	rv += vec2(0.0, 2.0) * texture(input_map, UV+e.zx).r;
	rv += vec2(0.0, -2.0) * texture(input_map, UV-e.zx).r;
	
	rv *= normal_strength;
	
	rv = rv * .5 + .5;
	
	COLOR = vec4(rv, 1.0, 1.0);
}