shader_type canvas_item;

uniform bool enabled = false;
uniform float duration:hint_range(0.0, 10.0) = 1.0;
uniform vec3 to_colour:source_color;

void fragment() {
	COLOR.rgb = to_colour.rgb;

	if (enabled) {
		float time_normalised = mod(TIME, duration) / duration;
		COLOR.a = 1.0 - time_normalised;
	}
}
