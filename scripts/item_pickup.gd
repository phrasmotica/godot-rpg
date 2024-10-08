@tool
class_name ItemPickup extends Node2D

@export
var item: Item:
	set(value):
		item = value

		update_sprite()

@onready
var sprite: AnimatedSprite2D = %Sprite

func _ready():
	update_sprite()

func update_sprite():
	if sprite:
		sprite.sprite_frames.clear("default")
		sprite.sprite_frames.add_frame("default", item.icon)
