shader_type canvas_item;

uniform sampler2D NOISE_PATTERN;
uniform float MAGNITUDE:hint_range(20.0, 100.0) = 20.0;
uniform float SPEED:hint_range(1.0, 5.0) = 1.0;

vec2 get_offset(int id, vec2 coords) {
	return MAGNITUDE * vec2(sign(coords.x - 0.5), sign(coords.y - 0.5));
}

vec2 get_progress(int id) {
	float angle_offset = float(id) * PI / 2.0;
	float angle = SPEED * TIME + angle_offset;

	return vec2(cos(angle), sin(angle));
}

void vertex() {
	VERTEX.xy += get_offset(VERTEX_ID, VERTEX.xy);
	VERTEX.xy += MAGNITUDE * get_progress(VERTEX_ID);
}

void fragment() {
	vec4 noiseValue = texture(NOISE_PATTERN, UV);
	//vec4 noiseValue = texture(NOISE_PATTERN, sin(TIME) * UV);
    COLOR.rgba = noiseValue;
}
