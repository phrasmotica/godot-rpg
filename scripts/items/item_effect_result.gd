class_name ItemEffectResult

var _item: Item
var _dialogue_timeline := ""

func _init(item: Item, dialogue_timeline: String) -> void:
	_item = item
	_dialogue_timeline = dialogue_timeline

func process_for_dialogue() -> void:
	if _dialogue_timeline:
		Dialogic.VAR.item_name = _item.name
		DialogueManager.start_timeline(_dialogue_timeline)
