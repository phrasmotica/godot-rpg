@tool
extends Menu

@export
var content: Control

@export
var hp_label: Label

func _on_hit_points_current_hp_changed(hp: int, max_hp: int):
	if hp_label:
		hp_label.text = str(hp) + "/" + str(max_hp) + " HP"

func _on_dimmer_dimmed():
	content.hide()

func _on_dimmer_undimmed():
	content.show()
