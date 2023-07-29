shader_type spatial;
#include "helpers.gdshaderinc"
render_mode cull_disabled;

uniform float wind_speed = 0.2;
uniform float wind_strength = 2.0;
// How big, in world space, is the noise texture
// wind will tile every wind_texture_tile_size
uniform float wind_texture_tile_size = 20.0;
uniform float wind_vertical_strength = 0.3;
uniform vec2 wind_horizontal_direction = vec2(1.0,0.5);

uniform sampler2D color_ramp : source_color;
uniform sampler2D color_texture : hint_default_black;
// we need a tiling noise here!
uniform sampler2D wind_noise : hint_default_black;

uniform sampler2D simulation_texture : hint_default_black;

varying vec3 world_vert;

void vertex() {
	world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec2 normalized_wind_direction = normalize(wind_horizontal_direction);
	vec2 world_uv = world_vert.xz / wind_texture_tile_size + 
			normalized_wind_direction * TIME * wind_speed;
	// we displace only the top part of the mesh
	// note that this means that the mesh needs to have UV in a way that the bottom of UV space
	// is at the top of the mesh
	float displacement_affect = 1.0 - UV.y;
	float wind_noise_intensity = (textureLod(wind_noise, world_uv , 0.0).r - 0.5);

	// We convert the direction of the wind into vertex space from world space
	// if we used it directly in vertex space, rotated blades of grass wouldn't behave properly
	vec2 vert_space_horizontal_dir = (inverse(MODEL_MATRIX) * vec4(wind_horizontal_direction, 0.0,0.0)).xy;
	vert_space_horizontal_dir = normalize(vert_space_horizontal_dir);

	vec3 bump_wind = vec3(
		wind_noise_intensity * vert_space_horizontal_dir.x,
		1.0 - wind_noise_intensity,
		wind_noise_intensity * vert_space_horizontal_dir.y 
	);
	normalize(bump_wind);
	bump_wind *= vec3(
		wind_strength,
		wind_vertical_strength,
		wind_strength
	);

	// simulation
	float cam_size = 40.0;
	vec2 world_uv_interact = world_vert.xz;
	world_uv_interact /= cam_size;
	world_uv_interact += vec2(0.5);
	vec2 simulation = texture(simulation_texture, world_uv_interact).rg;
	VERTEX = rotate_about_axis(VERTEX, normalize(vec3(simulation.x, 0.0, simulation.y)), 
		clamp(length(simulation), 0.0, 0.9) * PI / 2.0);
	
	VERTEX += mix(bump_wind * displacement_affect, vec3(0.0), length(simulation));
	
	NORMAL = vec3(0.0,1.0,0.0);
}

void fragment() {
	vec3 color_tex = texture(color_texture, UV).rgb;
	vec3 color_mod = texture(color_ramp, vec2(1.0 - UV.y, 0)).rgb ;
	ALBEDO = color_tex * color_mod;
	NORMAL *= FRONT_FACING ? 1.0 : -1.0;
}