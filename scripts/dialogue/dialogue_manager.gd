class_name DialogueManager extends Node

signal timeline_started
signal timeline_ended

func _ready():
    Dialogic.timeline_started.connect(handle_timeline_started)
    Dialogic.timeline_ended.connect(handle_timeline_ended)

func _on_bag_added_item(new_item: Item, _item_stacks: Array[ItemStack]):
    Dialogic.VAR.item_name = new_item.name
    Dialogic.start("picked_up_item")

func handle_timeline_started():
    print("Timeline started!")

    timeline_started.emit()

func handle_timeline_ended():
    print("Timeline ended!")

    timeline_ended.emit()

func _on_map_player_interacted(tile: Tile):
    if tile.dialogue_timeline.length() > 0:
        Dialogic.start(tile.dialogue_timeline)
