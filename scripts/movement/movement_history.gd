class_name MovementHistory extends Node

@export
var party: Party

var _pos_history: Array[Vector2i] = []

func add_position(pos: Vector2i) -> void:
    if party:
        party.follow_player(_pos_history)

    print("Player moved to position " + str(pos))

    _pos_history.push_front(pos)
