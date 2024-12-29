class_name Party extends Node2D

@export
var members: Array[NPC] = []

func follow_player(positions: Array[Vector2i]):
    for i in range(min(members.size(), positions.size())):
        var member := members[i]
        var pos := positions[i]

        member.move_to(pos, true)

func get_colliders() -> Array[CollisionShape2D]:
    var colliders: Array[CollisionShape2D] = []

    for m in members:
        colliders.append(m.collision_shape)

    return colliders
