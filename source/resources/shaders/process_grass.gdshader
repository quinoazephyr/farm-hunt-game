shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float trail_time = 3.0;

uniform sampler2D grass_input;
uniform sampler2D terrain_height;

uniform vec3 movement_vector;
uniform vec3 camera_position;

uniform float intersection_depth : hint_range(0.0, 2.0) = 0.25; // the grass colliders around the characters have a radius 0.25 bigger than the actual characters.
uniform float camera_size = 20.0;
uniform float terrain_height_span = 1.0;

void fragment() {
	{
		float inp = texture(grass_input, vec2(UV.x, 1.0 - UV.y)).r + 1.0 / terrain_height_span * intersection_depth; // this is the render of the grass interaction colliders
		float inv_height = texture(terrain_height, UV + camera_position.xz / camera_size).r; // We read in the height in the area,  we invert (??????) it.
		float intersection = 1.0 - clamp(inp - inv_height, 0.0, 1.0); // we see how much the input sticks into the height
		
		vec2 uv_mirror = vec2(min(UV.x, 1.0 - UV.x), min(UV.y, 1.0 - UV.y));
		float mask = max( float(uv_mirror.x < 0.01), float(uv_mirror.y < 0.01));
		
		vec3 pre_fr = texture(SCREEN_TEXTURE, UV - movement_vector.xz / camera_size).rgb; // we read in the previous frame, offset by movement_vector
		
		pre_fr = max(pre_fr, mask);
		
		pre_fr.g = clamp(pre_fr.g + 1.0 / 60.0 / trail_time, 0.0, 1.0); // we brighten the previous frame to make it fade out.
		
		vec3 final;
		final.r = min(pre_fr.r, intersection);
		final.g = min(pre_fr.g, intersection); // we mix current input the offset previous frame
		float diff = max(0.0, final.g - final.r) * trail_time;
		diff = min(diff, step(final.g, 0.99));
		final.b = diff;
		if (final.b < pre_fr.b) {
			final.r = intersection;
			final.b = 0.0;
		}
		
		//float g_mask = step(0.99, final.r);
		//final.g = max(final.g, g_mask);
		
		COLOR = vec4(final.rgb, 1.0);
		//COLOR = vec4(vec3(intersection), 1.0);
	}
	
}