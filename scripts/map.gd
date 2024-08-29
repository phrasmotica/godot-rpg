extends Node2D

@export
var tile_map_layer: TileMapLayer

@export
var tile_detection: TileDetection

var player_facing_tile_data: Tile

signal player_faced_tile(tile: Tile)
signal player_interacted(tile: Tile)

func _on_player_position_faced(pos: Vector2):
	player_facing_tile_data = tile_detection.get_tile_data(pos, tile_map_layer)

	print("Player faced tile ID=" + str(player_facing_tile_data.id))

	player_faced_tile.emit(player_facing_tile_data)

func _on_player_interacted():
	if player_facing_tile_data:
		print("Player interacted with tile ID=" + str(player_facing_tile_data.id))
		player_interacted.emit(player_facing_tile_data)
