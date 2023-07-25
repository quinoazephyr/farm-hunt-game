shader_type canvas_item;

uniform float trail_length = 10.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D collision_texture;

void fragment() {
	vec3 color = texture(screen_texture, UV).rgb;
	vec2 prev_color = color.rg;
	
	vec2 cur_collision = texture(collision_texture, vec2(UV.x, 1.0 - UV.y)).rg;
	
	vec2 new_color = cur_collision + prev_color * (1.0 - cur_collision);
	new_color -= prev_color / trail_length * 0.1;
	COLOR = vec4(vec3(new_color, 0.0), 1.0);
}
