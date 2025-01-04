@tool
extends ListMenu

@export
var item_consumer: ItemConsumer

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var next_frame_handler: NextFrameHandler = %NextFrameHandler

@onready
var description_label: Label = %Description

@onready
var use_item: MenuItem = %Use

@onready
var use_all_item: MenuItem = %UseAll

var selected_item: Item

var player_facing_tile: Tile

# MEDIUM: assign values of this enum to the menu items, rather than mapping
# menu item indexes to these enum values
enum UseItemAction { USE, USE_ALL, DROP, DROP_ALL, NONE }

signal use
signal use_all
signal drop
signal drop_all

func _ready():
	if items.size() > 0:
		current_index = 0

	if Engine.is_editor_hint():
		return

	toggle_bag_menu_input_handler.toggled.connect(_handle_toggle_bag_menu)

	list_menu_input_handler.next.connect(_handle_next)
	list_menu_input_handler.previous.connect(_handle_previous)
	list_menu_input_handler.select.connect(_handle_select)

	disable_menu()

func _handle_next() -> void:
	if items.size() <= 0:
		return

	var i := 0
	while i == 0 or items[current_index].disabled:
		current_index = (current_index + 1) % items.size()

		i += 1

func _handle_previous() -> void:
	if items.size() <= 0:
		return

	var i := 0
	while i == 0 or items[current_index].disabled:
		# this weird maths ensures we wrap around to the bottom
		# if we're currently at the top
		current_index = (current_index + items.size() - 1) % items.size()

		i += 1

func _handle_select() -> void:
	var item := items[current_index]
	if item.disabled:
		return

	if item.is_cancel:
		cancel_menu()
	else:
		select_current()

func _on_bag_menu_select_stack(stack: ItemStack):
	next_frame_handler.on_next_frame(_show_menu.bind(stack))

func _show_menu(stack: ItemStack) -> void:
	print("Showing UseItemMenu for stack ID=" + str(stack.id))

	show()

	selected_item = stack.item

	update_for(selected_item)

	enable_menu()

func _on_bag_menu_selected_item_changed(item: Item):
	selected_item = item
	update_for(selected_item)

func _on_bag_used_item(_used_item: Item, _item_stacks: Array[ItemStack]):
	update_for(selected_item)

func _on_bag_consumed_item(_consumed_item:Item, _item_stacks:Array[ItemStack]):
	update_for(selected_item)

func update_for(item: Item):
	if not item:
		return

	if description_label:
		description_label.text = item.get_description()

	var cannot_use := not _can_use_item(item)

	use_item.disabled = cannot_use
	use_item.text = item.get_use_text()

	use_all_item.disabled = cannot_use
	use_all_item.text = item.get_use_all_text()

	next_if_disabled()

func _can_use_item(item: Item) -> bool:
	var facing_tile := item.get_required_facing_tile()
	var facing_correct_tile := not facing_tile or (player_facing_tile.id == facing_tile.id)

	var can_use := item_consumer.can_use(selected_item) or item_consumer.can_consume(selected_item)

	return facing_correct_tile and can_use

func _on_select_index(index: int):
	var action := get_action(index)

	match action:
		UseItemAction.USE:
			print("Using one item")
			use.emit()

		UseItemAction.USE_ALL:
			print("Using all items")
			use_all.emit()

		UseItemAction.DROP:
			print("Dropping one item")
			drop.emit()

		UseItemAction.DROP_ALL:
			print("Dropping all items")
			drop_all.emit()

func get_action(index: int) -> UseItemAction:
	match index:
		0: return UseItemAction.USE
		1: return UseItemAction.USE_ALL
		2: return UseItemAction.DROP
		3: return UseItemAction.DROP_ALL

	print("Unknown use item action " + str(index))
	return UseItemAction.NONE

func _on_cancel():
	print("Hiding UseItemMenu")

	disable_menu()

	hide()

func _on_map_player_faced_tile(tile: Tile):
	player_facing_tile = tile
