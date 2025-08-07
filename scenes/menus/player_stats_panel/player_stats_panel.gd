@tool
class_name PlayerStatsPanel extends Menu

@export
var player_hit_points: HitPoints

@onready
var dimmer: Dimmer = %Dimmer

@onready
var content: Control = %Content

@onready
var hp_label: Label = %HPLabel

func _ready() -> void:
	if player_hit_points:
		player_hit_points.current_hp_changed.connect(_handle_current_hp_changed)

func _handle_current_hp_changed(hp: int, max_hp: int) -> void:
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
