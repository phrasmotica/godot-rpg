@tool
extends MenuSet

# HIGH: remove this hard dependency on the bag menu. Use generalised logic in
# MenuSet class
@export
var bag_menu: Menu

@export
var bag_menu_dimmer: Dimmer

func after_ready():
	super.after_ready()

	bag_menu.menu_disabled.connect(handle_bag_menu_disabled)
	bag_menu.menu_enabled.connect(handle_bag_menu_enabled)

func _on_visibility_changed():
	set_process(visible)

func handle_bag_menu_disabled(_menu: Menu):
	print("BagMenu disabled, disabling GameMenu")

	set_process(false)

	bag_menu_dimmer.is_dimmed = true

func handle_bag_menu_enabled(_menu: Menu):
	print("BagMenu enabled, enabling GameMenu")

	set_process(true)

	bag_menu_dimmer.is_dimmed = false
