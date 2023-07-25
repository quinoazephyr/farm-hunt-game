shader_type canvas_item;
#include "helpers.gdshaderinc"

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount: hint_range(0.0, 5.0);
uniform float brightness = 0.15;
uniform float contrast = 1.2;
uniform float saturation = 1.5;

void fragment() {
	vec3 color = textureLod(screen_texture, SCREEN_UV, blur_amount).rgb;
	COLOR = brightness_matrix(brightness) * contrast_matrix(contrast) * 
			saturation_matrix(saturation) * vec4(color, 1.0);
}
