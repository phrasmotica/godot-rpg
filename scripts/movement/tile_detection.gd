class_name TileDetection

var _tile_map_layer: TileMapLayer = null

func _init(tile_map_layer: TileMapLayer) -> void:
	_tile_map_layer = tile_map_layer

func get_tile_data(global_pos: Vector2) -> Tile:
	var local_raycast_target := _tile_map_layer.to_local(global_pos)

	var tile := _tile_map_layer.local_to_map(local_raycast_target)
	var tile_data := _tile_map_layer.get_cell_tile_data(tile)

	return tile_data.get_custom_data("tile") as Tile
