class_name ItemEffectResult extends Resource

@export
var item: Item

@export
var dialogue_timeline := ""

func process_for_dialogue():
    if dialogue_timeline:
        Dialogic.VAR.item_name = item.name
