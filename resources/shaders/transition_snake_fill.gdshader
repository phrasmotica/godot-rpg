shader_type canvas_item;

uniform bool enabled = false;
uniform float duration:hint_range(0.0, 10.0) = 1.0;
uniform bool logarithmic_time = false;
uniform vec3 to_colour:source_color;
uniform int x_tile_count:hint_range(1, 10) = 4;
uniform int y_tile_count:hint_range(1, 10) = 3;

float time_curve(int order, int num_tiles) {
	if (logarithmic_time) {
		// this technically isn't logarithmic, but I can't
		// think of a better name at the moment...
		return sqrt(float(order) / float(num_tiles + 1));
	}

	return float(order) / float(num_tiles + 1);
}

float get_time_threshold(float x_pos, float y_pos) {
	int x_index = int(x_pos * float(x_tile_count));
	int y_index = int(y_pos * float(y_tile_count));

	int num_tiles = x_tile_count * y_tile_count;
	int order = y_index * x_tile_count + x_index;

	if (y_index % 2 == 1) {
		order = y_index * x_tile_count + (x_tile_count - x_index);
	}

	return time_curve(order, num_tiles);
}

float get_time_normalised() {
	return mod(TIME, duration) / duration;
}

void fragment() {
	COLOR.rgb = to_colour.rgb;

	if (enabled) {
		float time_threshold = get_time_threshold(UV.x, UV.y);
		float time_normalised = get_time_normalised();

		COLOR.a = time_threshold < time_normalised ? 1.0 : 0.0;
	}
}
