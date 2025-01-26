@tool
class_name UITransitionManager extends Node

@export
var bag: Bag

@export
var map: Map

@onready
var ui_transition_scene: PackedScene = load("res://scenes/ui/ui_transition.tscn")

# HIGH: create a scene for a generic transitions gate, and reuse it
var _interaction_transitions_gate := 0
var _item_transitions_gate := 0

signal interaction_transitions_finished(tile: Tile)
signal item_transitions_finished(item: Item)

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    if bag:
        bag.before_consume_item.connect(_handle_bag_before_consume_item)

    if map:
        map.player_interacted.connect(_handle_map_player_interacted)

func _handle_bag_before_consume_item(item: Item) -> void:
    _item_transitions_gate = 0

    if item.consume_transitions.size() <= 0:
        item_transitions_finished.emit(item)
        return

    for t in item.consume_transitions:
        _item_transitions_gate += 1

        var transition: UITransition = ui_transition_scene.instantiate()
        transition.inject(t)

        transition.finished.connect(
            func():
                _handle_item_transition_finished(item)
        , CONNECT_ONE_SHOT)

        add_child(transition)
        transition.owner = self

func _handle_item_transition_finished(item: Item) -> void:
    _item_transitions_gate -= 1

    if _item_transitions_gate <= 0:
        item_transitions_finished.emit(item)

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
