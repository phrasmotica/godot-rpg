extends Node

func is_water(global_pos: Vector2, tile_map: TileMap):
	var local_raycast_target := tile_map.to_local(global_pos)

	var tile := tile_map.local_to_map(local_raycast_target)
	var tile_data := tile_map.get_cell_tile_data(0, tile)

	return tile_data.get_custom_data("is_water") as bool
