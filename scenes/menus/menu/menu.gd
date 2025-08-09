class_name Menu extends Control

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)
signal menu_covered
signal menu_uncovered

signal steal_control(menu: Menu)

func disable() -> void:
	pass

func enable() -> void:
	pass

func cover() -> void:
	pass

func uncover() -> void:
	pass

func emit_steal_control() -> void:
	steal_control.emit(self)

func emit_menu_hidden() -> void:
	menu_hidden.emit(self)

func emit_menu_shown() -> void:
	menu_shown.emit(self)

func emit_menu_covered() -> void:
	menu_covered.emit()

func emit_menu_uncovered() -> void:
	menu_uncovered.emit()

func is_closed() -> bool:
	return false
