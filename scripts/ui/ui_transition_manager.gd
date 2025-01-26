@tool
extends Node

@export
var map: Map

@onready
var ui_transition_scene: PackedScene = load("res://scenes/ui/ui_transition.tscn")

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    if map:
        map.player_interacted.connect(_handle_map_player_interacted)

func _handle_map_player_interacted(tile: Tile) -> void:
    for t in tile.transitions_on_interact:
        var transition: UITransition = ui_transition_scene.instantiate()
        transition.inject(t)

        add_child(transition)
        transition.owner = self
