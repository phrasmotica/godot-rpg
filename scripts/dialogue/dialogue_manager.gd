class_name DialogueManager extends Node

@export
var ui_transition_manager: UITransitionManager

@export
var player: Player

@export
var bag: Bag

@export
var item_consumer: ItemConsumer

signal timeline_started
signal timeline_ended

func _ready():
    if ui_transition_manager:
        ui_transition_manager.interaction_transitions_finished.connect(_handle_interaction_transitions_finished)

    if player:
        player.dialogue_triggered.connect(_handle_player_dialogue_triggered)

    if bag:
        bag.added_item.connect(_handle_bag_added_item)

    if item_consumer:
        item_consumer.item_consume_result_created.connect(_handle_item_consumer_item_consume_result_created)
        item_consumer.item_effect_result_created.connect(_handle_item_consumer_item_effect_result_created)

    Dialogic.timeline_started.connect(handle_timeline_started)
    Dialogic.timeline_ended.connect(handle_timeline_ended)

func handle_timeline_started():
    print("Timeline started!")

    timeline_started.emit()

func handle_timeline_ended():
    print("Timeline ended!")

    timeline_ended.emit()

func _handle_interaction_transitions_finished(tile: Tile) -> void:
    if tile.dialogue_timeline.length() > 0:
        Dialogic.start(tile.dialogue_timeline)

func _handle_player_dialogue_triggered(timeline: String) -> void:
    if timeline:
        Dialogic.start(timeline)

func _handle_bag_added_item(new_item: Item, altered: bool, _item_stacks: Array[ItemStack]) -> void:
    if altered:
        pass
    else:
        Dialogic.VAR.item_name = new_item.name
        Dialogic.start("picked_up_item")

func _handle_item_consumer_item_consume_result_created(result: ItemConsumeResult) -> void:
    if result.dialogue_timeline:
        result.process_for_dialogue()
        Dialogic.start(result.dialogue_timeline)

func _handle_item_consumer_item_effect_result_created(result: ItemEffectResult) -> void:
    if result.dialogue_timeline:
        result.process_for_dialogue()
        Dialogic.start(result.dialogue_timeline)
