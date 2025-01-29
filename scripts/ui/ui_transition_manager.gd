@tool
class_name UITransitionManager extends Node

@export
var bag: Bag

@export
var map: Map

@onready
var ui_transition_scene: PackedScene = load("res://scenes/ui/ui_transition.tscn")

# HIGH: add more specific interaction/item functionality to the gate scenes
@onready
var _interaction_transitions_gate: UITransitionsGate = %InteractionTransitionsGate

@onready
var _item_transitions_gate: UITransitionsGate = %ItemTransitionsGate

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
    _item_transitions_gate.reset()

    if item.consume_transitions.size() <= 0:
        item_transitions_finished.emit(item)
        return

    for t in item.consume_transitions:
        _item_transitions_gate.hold()

        var transition := _create_transition(t)

        transition.finished.connect(
            func():
                if _item_transitions_gate.release():
                    item_transitions_finished.emit(item)
        , CONNECT_ONE_SHOT)

func _handle_map_player_interacted(tile: Tile) -> void:
    _interaction_transitions_gate.reset()

    if tile.transitions_on_interact.size() <= 0:
        interaction_transitions_finished.emit(tile)
        return

    for t in tile.transitions_on_interact:
        _interaction_transitions_gate.hold()

        var transition := _create_transition(t)

        transition.finished.connect(
            func():
                if _interaction_transitions_gate.release():
                    interaction_transitions_finished.emit(tile)
        , CONNECT_ONE_SHOT)

func _create_transition(params: UITransitionParams) -> UITransition:
    var transition: UITransition = ui_transition_scene.instantiate()
    transition.inject(params)

    add_child(transition)
    transition.owner = self

    return transition
