shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform sampler2D col_tex;

uniform float phase = 0.2;
uniform float attenuation = 0.999;
uniform float deltaUV = 3.0;

void fragment() {
	float dv = 1.0 / 512.0;
	float du = 1.0 / 512.0;
	vec3 duv = vec3(du, dv, 0) * deltaUV;
	
	vec3 c = texture(screen_texture, UV).rgb;

	float p = (2.0 * c.r - c.g + phase * (
		texture(screen_texture, UV - duv.zy).r +
		texture(screen_texture, UV + duv.zy).r +
		texture(screen_texture, UV - duv.xz).r +
		texture(screen_texture, UV + duv.xz).r
		- 4.2 * c.r)) * attenuation;
		
	vec2 col_uv = vec2(UV.x, 1.0 - UV.y);
	float col = texture(col_tex, col_uv).r;
	float prevCol = texture(screen_texture, UV).b;
	
	if (col > 0.0 && prevCol == 0.0) {
		p += col * 0.5;
	}
	
	if (prevCol > 0.0 && col == 0.0) {
		p -= prevCol * 0.5;
	}
	
	COLOR = vec4(p, c.r, col, 1);
}