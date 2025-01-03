@tool
extends Menu

@onready
var dimmer: Dimmer = %Dimmer

@onready
var content: Control = %Content

@onready
var hp_label: Label = %HPLabel

func _on_hit_points_current_hp_changed(hp: int, max_hp: int):
	if hp_label:
		hp_label.text = str(hp) + "/" + str(max_hp) + " HP"

func disable_menu():
	menu_disabled.emit(self)

	dimmer.is_dimmed = true
	_inactive = true

	content.hide()

func enable_menu():
	menu_enabled.emit(self)

	dimmer.is_dimmed = false
	_inactive = false

	content.show()
