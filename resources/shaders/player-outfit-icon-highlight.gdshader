shader_type canvas_item;

const vec3 hide_colour = vec3(0); // black
const float tolerance = 0.15;

void fragment() {
	if (distance(COLOR.rgb, hide_colour.rgb) < tolerance && COLOR.a > 0.1) {
		COLOR.a = 0.2;
	}
}
