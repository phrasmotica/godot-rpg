shader_type canvas_item;

// blue colour from player sprites
const vec3 base_torso_colour = vec3(0.212, 0.212, 0.886);

// yellow colour from player sprites
const vec3 base_sleeve_colour = vec3(0.8, 0.8, 0.349);

uniform vec3 torso_colour:source_color;
uniform vec3 sleeve_colour:source_color;
uniform float tolerance:hint_range(0, 1) = 0.01;

void fragment() {
	if (distance(COLOR.rgb, base_torso_colour.rgb) < tolerance) {
		COLOR.rgb = torso_colour.rgb;
	}
	else if (distance(COLOR.rgb, base_sleeve_colour.rgb) < tolerance) {
		COLOR.rgb = sleeve_colour.rgb;
	}
}
