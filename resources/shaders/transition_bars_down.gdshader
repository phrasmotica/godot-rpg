shader_type canvas_item;

uniform bool enabled = false;
uniform float duration:hint_range(0.0, 10.0) = 1.0;
uniform vec3 to_colour:source_color;
uniform int bar_count:hint_range(1, 10) = 1;

void fragment() {
	COLOR.rgb = to_colour.rgb;

	if (enabled) {
		float time_normalised = mod(TIME, duration) / duration;
		
		float bar_height = 1.0 / float(bar_count);
		float position_in_bar = mod(UV.y, bar_height) * float(bar_count);
		
		COLOR.a = position_in_bar < time_normalised ? 1.0 : 0.0;
	}
}
