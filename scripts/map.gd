class_name Map extends Node2D

@export
var player: Player

@onready
var tile_detection: TileDetection = %TileDetection

@onready
var tile_map_layer: TileMapLayer = %TileMapLayer

var player_facing_tile_data: Tile

signal player_faced_tile(tile: Tile)
signal player_interacted(tile: Tile)

func _ready() -> void:
	if player:
		player.position_faced.connect(_handle_player_position_faced)
		player.interacted.connect(_handle_player_interacted)

func _handle_player_position_faced(pos: Vector2) -> void:
	player_facing_tile_data = tile_detection.get_tile_data(pos, tile_map_layer)

	print("Player faced tile ID=" + str(player_facing_tile_data.id))

	player_faced_tile.emit(player_facing_tile_data)

func _handle_player_interacted() -> void:
	if player_facing_tile_data:
		print("Player interacted with tile ID=" + str(player_facing_tile_data.id))
		player_interacted.emit(player_facing_tile_data)
