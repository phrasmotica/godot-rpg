class_name Party extends Node

@export
var members: Array[NPC] = []

func _ready() -> void:
	for m in members:
		m.add_to_party()

func follow_player(positions: Array[Vector2i]) -> void:
	for i in range(min(members.size(), positions.size())):
		# TODO: make member n follow member n-1. This is required, otherwise
		# member n cannot start following until the player has registered being
		# in n+1 positions...
		var member := members[i]
		var pos := positions[i]

		member.move_to(pos)

func get_colliders() -> Array[CollisionShape2D]:
	var colliders: Array[CollisionShape2D] = []

	for m in members:
		colliders.append(m.collision_shape)

	return colliders
