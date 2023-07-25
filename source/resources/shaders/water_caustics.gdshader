shader_type spatial;
#include "simplex_noise.gdshaderinc"

uniform vec3 _albedo : source_color;
uniform float caustics_speed = 0.2;
uniform float caustics_size = 1.0;
uniform float caustics_intensity = 3.0;
uniform float water_level = 0.0;
uniform float caustics_depth = -1.0;

varying vec3 world_vert;

void vertex() {
	world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Caustics
	vec3 caustics_uv = world_vert;// + simulation_sample.rgb;
	caustics_uv.y = TIME * caustics_speed;
    caustics_uv *= caustics_size;
	vec4 n = snoise(caustics_uv);        
	caustics_uv -= 0.07 * n.xyz;
	n = snoise(caustics_uv);
	caustics_uv -= 0.07 * n.xyz;
	n = snoise(caustics_uv);
	float intensity = exp(n.w * caustics_intensity - caustics_intensity) * 
		 step(world_vert.y, water_level) * smoothstep(caustics_depth, water_level, world_vert.y);
	
	ALBEDO = _albedo + intensity;
	EMISSION = vec3(intensity);
}
