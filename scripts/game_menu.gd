@tool
extends MenuSet

func _on_visibility_changed():
	set_process(visible)
