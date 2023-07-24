shader_type spatial;
render_mode cull_disabled;

uniform float wind_speed = 0.2;
uniform float wind_strength = 2.0;
// How big, in world space, is the noise texture
// wind will tile every wind_texture_tile_size
uniform float wind_texture_tile_size = 20.0;
uniform float wind_vertical_strength = 0.3;
uniform vec2 wind_horizontal_direction = vec2(1.0,0.5);

uniform sampler2D color_ramp : hint_default_black;
uniform sampler2D color_texture : hint_default_black;
// we need a tiling noise here!
uniform sampler2D wind_noise : hint_default_black;

uniform vec3 camera_position;
uniform sampler2D sway_curve;
uniform sampler2D normal_map : hint_normal;
uniform sampler2D interact_map;

varying vec3 world_vert;
varying vec2 world_uv_interact;

varying float test;

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
//	VERTEX += bump_wind * displacement_affect;
	
	float cam_size = 40.0;
	world_uv_interact = world_vert.xz;
	world_uv_interact /= cam_size;
	world_uv_interact += vec2(0.5);
	vec2 normal_tex = texture(normal_map, world_uv_interact - camera_position.xz / cam_size).rg;
	vec3 interact_tex = texture(interact_map, world_uv_interact - camera_position.xz/ cam_size).rgb;
	
//	float diff = max(0.0, interact_tex.g - interact_tex.r) * 10.0;
//	diff = min(diff, step(interact_tex.g, 0.99));
//	test = diff;
	
	float curve = texture(sway_curve, vec2(interact_tex.b)).r - .5;
	normal_tex = normal_tex * 2.0 - 1.0;
	
	
	
	
	VERTEX.xz += normal_tex * vec2(UV.x, 1.0 - UV.y);// * 4.0 * curve;
	
	NORMAL = vec3(0.0,1.0,0.0);
}

void fragment() {
	vec3 color_tex = texture(color_texture, UV).rgb;
	vec3 color_mod = texture(color_ramp, vec2(1.0 - UV.y, 0)).rgb ;
	ALBEDO = color_tex * color_mod;
	NORMAL *= FRONT_FACING ? 1.0 : -1.0;
//	ALBEDO = vec3(test);
}