shader_type canvas_item;

uniform sampler2D viewport_texture;

void fragment() {
	COLOR = texture(viewport_texture, UV);
}
