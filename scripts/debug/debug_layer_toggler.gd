extends Node

@export
var debug_canvas_layer: CanvasLayer

func _ready() -> void:
	if debug_canvas_layer:
		debug_canvas_layer.visible = false

	ToggleDebugModeInputHandler.toggled.connect(_on_toggled)

func _on_toggled() -> void:
	if debug_canvas_layer:
		debug_canvas_layer.visible = not debug_canvas_layer.visible
