class_name ItemStackMenuItem extends VBoxContainer

@export
var pointer: TextureRect

@export
var name_label: Label

@export
var amount_label: Label

@export
var animation_player: AnimationPlayer

var stack: ItemStack:
	set(value):
		stack = value

		var name_text := "<empty stack>"
		var amount_text := ""

		if stack and stack.amount > 0:
			if stack.item:
				name_text = stack.item.get_display_name()

			amount_text = "x" + str(stack.amount)

		if name_label:
			name_label.text = name_text

		if amount_label:
			amount_label.text = amount_text

var index := -1

func select():
	pointer.show()

func deselect():
	pointer.hide()

func disable_item():
	if animation_player:
		animation_player.pause()

func enable_item():
	if animation_player:
		animation_player.play()
