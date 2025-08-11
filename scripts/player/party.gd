class_name Party extends Node2D

@export
var members: Array[NPC] = []

func _ready() -> void:
	for m in members:
		m.add_to_party()

func follow_player(positions: Array[Vector2i]):
	# BUG: this isn't quite working. NPCs are overlapping, or moving too far?
	for i in range(min(members.size(), positions.size())):
		# TODO: make member n follow member n-1. This is the more general form
		# of making each member move to the (i-n)th position of the player's
		# movement history...
		var member := members[i]
		var pos := positions[i]

		member.move_to(pos)

func get_colliders() -> Array[CollisionShape2D]:
	var colliders: Array[CollisionShape2D] = []

	for m in members:
		colliders.append(m.collision_shape)

	return colliders
