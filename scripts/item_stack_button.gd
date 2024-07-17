class_name ItemStackButton extends Button

@export
var name_label: Label

@export
var amount_label: Label

signal focused(button: ItemStackButton)

var stack: ItemStack:
	set(value):
		stack = value

		var name_text := "<empty stack>"
		var amount_text := ""

		if stack:
			if stack.item:
				name_text = stack.item.name

			amount_text = "x" + str(stack.amount)

		if name_label:
			name_label.text = name_text

		if amount_label:
			amount_label.text = amount_text

func _on_focus_entered():
	focused.emit(self)
