class_name Map extends Node2D

@export
var player: Player

@onready
var tile_map_layer: TileMapLayer = %TileMapLayer

var _player_facing_tile_data: Tile = null
var _tile_detection: TileDetection = null

signal player_faced_tile(tile: Tile)

func _ready() -> void:
	_tile_detection = TileDetection.new(tile_map_layer)

	if player:
		player.position_faced.connect(_handle_player_position_faced)
		player.interacted.connect(_handle_player_interacted)

func _handle_player_position_faced(pos: Vector2) -> void:
	_player_facing_tile_data = _tile_detection.get_tile_data(pos)

	print("Player faced tile ID=%d" % _player_facing_tile_data.id)

	player_faced_tile.emit(_player_facing_tile_data)

func _handle_player_interacted() -> void:
	if _player_facing_tile_data:
		print("Player interacted with tile ID=%d" % _player_facing_tile_data.id)

		InteractionTransitionsHandler.add(_player_facing_tile_data)
