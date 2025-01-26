@tool
class_name UITransitionManager extends Node

@export
var map: Map

@onready
var ui_transition_scene: PackedScene = load("res://scenes/ui/ui_transition.tscn")

var _interaction_transitions_gate := 0

signal interaction_transitions_finished(tile: Tile)

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    if map:
        map.player_interacted.connect(_handle_map_player_interacted)

func _handle_map_player_interacted(tile: Tile) -> void:
    _interaction_transitions_gate = 0

    if tile.transitions_on_interact.size() <= 0:
        interaction_transitions_finished.emit(tile)
        return

    for t in tile.transitions_on_interact:
        _interaction_transitions_gate += 1

        var transition: UITransition = ui_transition_scene.instantiate()
        transition.inject(t)

        transition.finished.connect(
            func():
                _handle_interaction_transition_finished(tile)
        , CONNECT_ONE_SHOT)

        add_child(transition)
        transition.owner = self

func _handle_interaction_transition_finished(tile: Tile) -> void:
    _interaction_transitions_gate -= 1

    if _interaction_transitions_gate <= 0:
        interaction_transitions_finished.emit(tile)
