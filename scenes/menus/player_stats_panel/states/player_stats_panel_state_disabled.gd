class_name PlayerStatsPanelStateDisabled
extends PlayerStatsPanelState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_connect_signals()

	_dimmer.is_dimmed = true

	_content.hide()
