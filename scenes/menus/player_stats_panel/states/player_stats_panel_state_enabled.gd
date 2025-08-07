class_name PlayerStatsPanelStateEnabled
extends PlayerStatsPanelState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_connect_signals()

	_dimmer.is_dimmed = false

	_content.show()
