class_name DialogueManager extends Node

@export
var map: Map

@export
var player: Player

@export
var bag: Bag

@export
var item_consumer: ItemConsumer

@onready
var signal_event_handler: DialogicSignalEventHandler = %DialogicSignalEventHandler

var _resume_npc_moving := true

signal timeline_started
signal timeline_ended

signal choose_item_from_bag

func _ready() -> void:
    if map:
        map.player_interacted.connect(_handle_map_player_interacted)

    if player:
        player.dialogue_triggered.connect(_handle_player_dialogue_triggered)

    if bag:
        bag.added_item.connect(_handle_bag_added_item)

    if item_consumer:
        item_consumer.item_consume_result_created.connect(_handle_item_consumer_item_consume_result_created)
        item_consumer.item_effect_result_created.connect(_handle_item_consumer_item_effect_result_created)

    Dialogic.timeline_started.connect(handle_timeline_started)
    Dialogic.timeline_ended.connect(handle_timeline_ended)
    Dialogic.signal_event.connect(signal_event_handler.handle)

    signal_event_handler.choose_item_from_bag.connect(_handle_choose_item_from_bag)

func try_resume() -> void:
    var timeline: String = Dialogic.VAR.resume_with_timeline
    if timeline.length() > 0:
        print("Resuming with dialogue timeline %s" % timeline)

        Dialogic.VAR.resume_with_timeline = ""
        Dialogic.start(timeline)

func is_busy() -> bool:
    return Dialogic.current_timeline != null

func handle_timeline_started() -> void:
    print("Timeline started!")

    timeline_started.emit()

func handle_timeline_ended() -> void:
    var timeline: String = Dialogic.VAR.resume_with_timeline

    print("Timeline ended! Resume timeline=%s" % timeline)

    timeline_ended.emit()

func _handle_choose_item_from_bag() -> void:
    # NPC should at least wait for us to choose the item from the bag
    _resume_npc_moving = false

    choose_item_from_bag.emit()

func _handle_map_player_interacted(tile: Tile) -> void:
    if tile.dialogue_timeline.length() > 0:
        Dialogic.start(tile.dialogue_timeline)

func _handle_player_dialogue_triggered(npc: NPC) -> void:
    var timeline := npc.get_talk_dialogue()
    if timeline:
        Dialogic.timeline_ended.connect(
            func():
                _handle_npc_dialogue_ended(npc)
        , CONNECT_ONE_SHOT)

        Dialogic.start(timeline)

func _handle_npc_dialogue_ended(npc: NPC) -> void:
    if _resume_npc_moving:
        npc.resume_moving()
    else:
        print("NOT resuming movement for %s" % npc.name)

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
