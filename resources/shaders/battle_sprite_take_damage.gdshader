shader_type canvas_item;

uniform float DURATION_SECONDS:hint_range(0.05, 0.3) = 0.1;
uniform vec3 DAMAGE_COLOUR:source_color;

void fragment() {
	float progress = TIME / DURATION_SECONDS;
	float mix_factor = 0.5 * (sin(progress) + 1.0);

	COLOR.rgb = mix(COLOR.rgb, DAMAGE_COLOUR, mix_factor);
}
