shader_type canvas_item;

// brown colour from player sprites
const vec3 base_hair_colour = vec3(0.125, 0.008, 0.012);

// blue colour from player sprites
const vec3 base_torso_colour = vec3(0.212, 0.212, 0.886);

// yellow colour from player sprites
const vec3 base_sleeve_colour = vec3(0.8, 0.8, 0.349);

uniform vec3 hair_colour:source_color;
uniform vec3 torso_colour:source_color;
uniform vec3 sleeve_colour:source_color;

uniform float tolerance:hint_range(0, 1) = 0.01;

void fragment() {
	// TODO: this hair tolerance needs improving. Rather, the
	// base sprite needs improving...
	if (distance(COLOR.rgb, base_hair_colour.rgb) < 8.0 * tolerance) {
		COLOR.rgb = hair_colour.rgb;
	}
	else if (distance(COLOR.rgb, base_torso_colour.rgb) < tolerance) {
		COLOR.rgb = torso_colour.rgb;
	}
	else if (distance(COLOR.rgb, base_sleeve_colour.rgb) < tolerance) {
		COLOR.rgb = sleeve_colour.rgb;
	}
}
