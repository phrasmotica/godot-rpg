extends Node

@export
var player: Player

@export
var party: Party

var _pos_history: Array[Vector2i] = []

func _ready() -> void:
    if player:
        player.moving_to_position.connect(handle_player_moving_to_position)

func handle_player_moving_to_position(pos: Vector2i) -> void:
    if party:
        party.follow_player(_pos_history)

    print("Player moved to position " + str(pos))

    _pos_history.push_front(pos)
