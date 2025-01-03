@tool
extends Menu

@onready
var dimmer: Dimmer = %Dimmer

@onready
var content: Control = %Content

@onready
var hp_label: Label = %HPLabel

func _on_hit_points_current_hp_changed(hp: int, max_hp: int) -> void:
	if hp_label:
		hp_label.text = str(hp) + "/" + str(max_hp) + " HP"

func disable_menu() -> void:
	dimmer.is_dimmed = true
	menu_state_handler.disable()

	content.hide()

func enable_menu() -> void:
	dimmer.is_dimmed = false
	menu_state_handler.enable()

	content.show()
