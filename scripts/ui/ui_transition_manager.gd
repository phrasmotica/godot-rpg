class_name UITransitionManager extends Node

@export
var bag: Bag

@export
var map: Map

@onready
var _interaction_handler: InteractionTransitionsHandler = %InteractionHandler

@onready
var _item_handler: ItemTransitionsHandler = %ItemHandler

signal item_transitions_finished(item: Item)

func _ready() -> void:
    if bag:
        bag.before_consume_item.connect(_item_handler.handle_item)

    if map:
        map.player_interacted.connect(_interaction_handler.handle_interaction)

    _interaction_handler.finished.connect(_on_interaction_handler_finished)
    _item_handler.finished.connect(item_transitions_finished.emit)

func _on_interaction_handler_finished(tile: Tile) -> void:
    if tile.dialogue_timeline.length() > 0:
        DialogueManager.start_timeline(tile.dialogue_timeline)
