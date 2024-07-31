class_name TextBox extends PanelContainer

@export
var fixed_speed := false

@onready
var label: Label = %Label

func _ready():
	label.visible_ratio = 0

func _process(delta):
	if fixed_speed:
		progress_chars()
	else:
		progress_ratio(delta)

func set_text(text: String):
	label.text = text
	label.visible_ratio = 0

func progress_chars():
	if label.visible_ratio < 1:
		# crawls 1 character per update
		label.visible_characters += 1

func progress_ratio(delta: float):
	if label.visible_ratio < 1:
		# all text will take 3 seconds to crawl
		label.visible_ratio += delta / 3

func _on_bag_added_item(new_item: Item, _item_stacks: Array[ItemStack]):
	set_text("You picked up the " + new_item.name + ".")
