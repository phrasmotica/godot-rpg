@tool
extends Menu

@onready
var content: Control = %Content

@onready
var hp_label: Label = %HPLabel

func _on_hit_points_current_hp_changed(hp: int, max_hp: int):
	if hp_label:
		hp_label.text = str(hp) + "/" + str(max_hp) + " HP"

func hide_content():
	content.hide()

func show_content():
	content.show()
