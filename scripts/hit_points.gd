@tool
class_name HitPoints extends Node

@export_range(10, 100)
var max_hp := 50:
    set(value):
        max_hp = value

        if current_hp > max_hp:
            # signal will be emitted by the current_hp setter
            current_hp = max_hp
        else:
            current_hp_changed.emit(current_hp, max_hp)

@export_range(10, 100)
var current_hp := 50:
    set(value):
        current_hp = min(max_hp, value)

        current_hp_changed.emit(current_hp, max_hp)

signal current_hp_changed(hp: int, max_hp: int)

func _ready():
    current_hp_changed.emit(current_hp, max_hp)

func _on_ui_manager_ui_ready():
    current_hp_changed.emit(current_hp, max_hp)
