extends Node

@export
var toggle: GUIDEAction

@export
var debug_layer: CanvasLayer

func _ready() -> void:
    toggle.triggered.connect(_handle_toggle_triggered)

func _handle_toggle_triggered() -> void:
    debug_layer.visible = not debug_layer.visible
