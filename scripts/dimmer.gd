@tool
class_name Dimmer extends Node

@export
var to_dim: Control

@export
var is_dimmed := false:
    set(value):
        is_dimmed = value

        if is_dimmed:
            dim()
        else:
            undim()

func _ready():
    var m = to_dim as Menu
    if m:
        print("Ensuring " + m.name + " does not begin processing after being enabled if it's dimmed...")

        m.menu_enabled.connect(
            func():
                m.set_process(not is_dimmed)
        )

func dim():
    if to_dim:
        to_dim.modulate = Color.DARK_GRAY
        to_dim.set_process(false)

func undim():
    if to_dim:
        to_dim.modulate = Color.WHITE
        to_dim.set_process(true)
