class_name UseItemMenuUIUpdater extends Node

@export
var description_label: Label

@export
var use_item: MenuItem

@export
var use_all_item: MenuItem

func update_for(item: Item, can_use: bool) -> void:
	if not item:
		return

	if description_label:
		description_label.text = item.get_description()

	use_item.disabled = not can_use
	use_item.text = item.get_use_text()

	use_all_item.disabled = not can_use
	use_all_item.text = item.get_use_all_text()
