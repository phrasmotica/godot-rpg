shader_type canvas_item;

uniform vec3 base_colour:source_color;
uniform vec3 new_colour:source_color;

uniform float tolerance:hint_range(0, 1) = 0.01;

void fragment() {
	if (distance(COLOR.rgb, base_colour.rgb) < tolerance) {
		COLOR.rgb = new_colour.rgb;
	}
}
