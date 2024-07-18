@tool
extends Menu

func _on_bag_menu_select(stack_id:int):
	print("Showing UseItemMenu for stack ID=" + str(stack_id))

	show()

func _on_cancel():
	hide()
