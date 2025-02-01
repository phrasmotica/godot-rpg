shader_type canvas_item;

uniform bool enabled = false;
uniform float duration:hint_range(0.0, 10.0) = 1.0;
uniform vec3 to_colour:source_color;
uniform int bar_count:hint_range(1, 10) = 1;
uniform bool starts_right_to_left = false;

void fragment() {
	COLOR.rgb = to_colour.rgb;

	if (enabled) {
		float time_normalised = mod(TIME, duration) / duration;

		int bar_index = int(UV.y * float(bar_count));
		
		int modulo_check = starts_right_to_left ? 1 : 0;
		float position_in_bar = bar_index % 2 == modulo_check ? UV.x : 1.0 - UV.x;

		COLOR.a = position_in_bar < time_normalised ? 1.0 : 0.0;
	}
}
