class_name ItemButton extends Button

signal focused(button: ItemButton)

func _on_focus_entered():
	focused.emit(self)
