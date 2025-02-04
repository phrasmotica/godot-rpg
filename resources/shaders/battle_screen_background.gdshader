shader_type canvas_item;

uniform sampler2D NOISE_PATTERN;

void vertex() {
	VERTEX.xy += vec2(cos(TIME) * 20.0, sin(TIME) * 20.0);
}

void fragment() {
	vec4 noiseValue = texture(NOISE_PATTERN, UV);
	//vec4 noiseValue = texture(NOISE_PATTERN, sin(TIME) * UV);
    COLOR.rgba = noiseValue;
}
