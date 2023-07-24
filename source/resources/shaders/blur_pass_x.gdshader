shader_type canvas_item;

uniform sampler2D _texture;
uniform float blur_strength = 20.0;

void fragment() {
	
	float e = 1.0/512.0;
	vec4 rv = vec4(0.0);
	float sum = 0.0;
	float sigma = max(0.000001, blur_strength);
	for (float i = -50.0; i <= 50.0; i += 1.0) {
		float coef = exp(-0.5*(pow(i/sigma, 2.0)))/(6.28318530718*sigma*sigma);
		rv += texture(_texture, UV + vec2(i * e, 0.0)) * coef;
		sum += coef;
	}
	COLOR = rv/sum;
}