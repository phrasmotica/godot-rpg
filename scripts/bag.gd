class_name Bag extends Node

@export
var item_consumer: ItemConsumer

@onready
var stack_manager: StackManager = %StackManager

@onready
var item_pool: ItemPool = %ItemPool

signal added_item(new_item: Item, altered: bool, item_stacks: Array[ItemStack])
signal dropped_item(dropped_item: Item, item_stacks: Array[ItemStack])
signal used_item(used_item: Item, item_stacks: Array[ItemStack])
signal consumed_item(consumed_item: Item, item_stacks: Array[ItemStack])

func add_random_item():
	var item := item_pool.get_random()
	add_item(item)

func add_item(item: Item):
	var new_item = stack_manager.add_item(item)

	added_item.emit(new_item, false, stack_manager.get_stacks())

func try_use_item(stack_id: int):
	var item := stack_manager.peek(stack_id)

	if not item:
		print("Tried to use from stack ID=" + str(stack_id) + " but no item was found!")
		return

	var did_use := item_consumer.use(item)
	if not did_use:
		print("Did not use item " + item.name)
		return

	# take the item off the stack, we might put it back in the bag later
	stack_manager.drop_item(stack_id)
	print("Used " + item.name + " from stack ID=" + str(stack_id))

	used_item.emit(item, stack_manager.get_stacks())

	var did_consume := item_consumer.consume(item)
	if not did_consume:
		# add the item back in its possibly altered state after being used
		var altered_item := stack_manager.add_item(item)
		stack_manager.remove_empty_stacks()

		added_item.emit(altered_item, true, stack_manager.get_stacks())

		print("Did not consume item " + item.name)
		return

	print("Consumed " + item.name + " from stack ID=" + str(stack_id))

	stack_manager.remove_empty_stacks()

	consumed_item.emit(item, stack_manager.get_stacks())

func drop_item(stack_id: int):
	var just_dropped_item := stack_manager.drop_item(stack_id, true)

	dropped_item.emit(just_dropped_item, stack_manager.get_stacks())

func drop_stack(stack_id: int):
	var just_dropped_item := stack_manager.drop_stack(stack_id)

	dropped_item.emit(just_dropped_item, stack_manager.get_stacks())

func _on_bag_menu_use_item(stack_id: int):
	try_use_item(stack_id)

func _on_bag_menu_drop_item(stack_id: int):
	drop_item(stack_id)

func _on_bag_menu_drop_stack(stack_id: int):
	drop_stack(stack_id)

func _on_bag_menu_add_random_item():
	add_random_item()

func _on_player_pickup_item(item: Item):
	print("Player picked up " + item.name)

	add_item(item)
