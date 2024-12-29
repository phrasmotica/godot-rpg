class_name Party extends Node2D

@export
var members: Array[NPC] = []

func follow_player(positions: Array[Vector2i]):
    for i in range(min(members.size(), positions.size())):
        var member := members[i]
        var pos := positions[i]

        member.move_to(pos, true)
