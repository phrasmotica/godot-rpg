@tool
extends Node2D

@export
var item: Item:
	set(value):
		item = value

		if sprite:
			sprite.sprite_frames.clear("default")
			sprite.sprite_frames.add_frame("default", item.icon)

@export
var sprite: AnimatedSprite2D

var _player_looking := false

func _on_item_area_player_is_looking():
	print("Player is looking at " + item.name)

	_player_looking = true
