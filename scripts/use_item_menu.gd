@tool
extends Menu

signal use
signal use_all
signal drop
signal drop_all

func _on_bag_menu_select(stack_id: int):
	print("Showing UseItemMenu for stack ID=" + str(stack_id))

	show()

func _on_select(index: int):
	match index:
		0: use.emit()
		1: use_all.emit()
		2: drop.emit()
		3: drop_all.emit()

func _on_cancel():
	print("Hiding UseItemMenu")

	hide()
