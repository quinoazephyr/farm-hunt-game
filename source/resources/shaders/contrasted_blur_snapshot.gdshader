shader_type canvas_item;
#include "helpers.gdshaderinc"

uniform sampler2D _texture;

uniform int blur_samples = 35;
uniform int blur_LOD = 2;         // gaussian done on MIPmap at scale LOD

uniform float brightness = 0.15;
uniform float contrast = 1.2;
uniform float saturation = 1.5;

float gaussian(vec2 i) {
	float sigma = float(blur_samples) * .25;
	return exp( -.5* dot(i/=sigma,i) ) / ( 6.28 * sigma*sigma );
}

vec4 blur(sampler2D sp, vec2 U, vec2 scale) {
	int sLOD = 1 << blur_LOD; // tile size = 2^LOD
	float sigma = float(blur_samples) * .25;
	vec4 O = vec4(0);  
	int s = blur_samples/sLOD;
	for ( int i = 0; i < s*s; i++ ) {
		vec2 d = vec2(float(i%s), float(i/s))*float(sLOD) - float(blur_samples)/2.;
		O += gaussian(d) * textureLod( sp, U + scale * d , float(blur_LOD) );
	}
	return O / O.a;
}

void fragment() {
	vec4 color = blur(_texture, SCREEN_UV * TEXTURE_PIXEL_SIZE, SCREEN_PIXEL_SIZE);
	COLOR = brightness_matrix(brightness) * contrast_matrix(contrast) * 
			saturation_matrix(saturation) * color;
}
