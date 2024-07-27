extends Node2D

@export
var tile_map: TileMap

@export
var tile_detection: TileDetection

signal player_faced_tile(tile_id: int)

func _on_player_position_faced(pos: Vector2):
	var tile_id := tile_detection.get_tile_id(pos, tile_map)

	print("Player faced tile ID=" + str(tile_id))

	player_faced_tile.emit(tile_id)

