@tool
class_name ItemPickup extends Node2D

@export
var item: Item:
	set(value):
		item = value

		if sprite:
			sprite.sprite_frames.clear("default")
			sprite.sprite_frames.add_frame("default", item.icon)

@export
var sprite: AnimatedSprite2D
