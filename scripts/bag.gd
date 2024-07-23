class_name Bag extends Node

@export
var item_pool: ItemPool

var item_stacks: Array[ItemStack] = []

signal added_item(new_item: Item, item_stacks: Array[ItemStack])
signal dropped_item(dropped_item: Item, item_stacks: Array[ItemStack])

func add_random_item():
	var new_item := item_pool.get_random()
	add_item(new_item)

func add_item(new_item: Item):
	var existing_stack := find_stack(new_item)

	if existing_stack:
		print("Pushing " + new_item.name + " to stack ID " + str(existing_stack.id))

		existing_stack.push(new_item)
	else:
		print("Creating new stack for " + new_item.name)

		var new_stack = ItemStack.new()

		var max_id = item_stacks.map(func(s): return s.id).max()
		if max_id:
			new_stack.id = int(max_id) + 1
		else:
			new_stack.id = 1

		new_stack.push(new_item)
		item_stacks.append(new_stack)

	added_item.emit(new_item, item_stacks)

func find_stack(new_item: Item) -> ItemStack:
	var valid_stacks := item_stacks.filter(
		func(stack: ItemStack):
			return stack.will_accept(new_item)
	)

	return valid_stacks[0] if valid_stacks.size() > 0 else null

func try_use_item(stack_id: int):
	var stack := get_stack_with_id(stack_id)

	if not stack:
		print("Tried to use from stack ID=" + str(stack_id) + " but no such stack exists!")
		return

	# HIGH: verify that the item can be used, then make its effect happen

	var just_dropped_item := stack.drop(1)
	if not just_dropped_item:
		print("Tried to use from stack ID=" + str(stack_id) + " but the stack was empty!")
		return

	print("Used from stack ID=" + str(stack_id))

	remove_empty_stacks()

	dropped_item.emit(just_dropped_item, item_stacks)

func drop_item(stack_id: int):
	var stack := get_stack_with_id(stack_id)

	if not stack:
		print("Tried to drop from stack ID=" + str(stack_id) + " but no such stack exists!")
		return

	var just_dropped_item := stack.drop(1)
	if not just_dropped_item:
		print("Tried to drop from stack ID=" + str(stack_id) + " but the stack was empty!")
		return

	print("Dropped from stack ID=" + str(stack_id))

	remove_empty_stacks()

	dropped_item.emit(just_dropped_item, item_stacks)

func drop_stack(stack_id: int):
	var stack := get_stack_with_id(stack_id)

	if not stack:
		print("Tried to drop all of stack ID=" + str(stack_id) + " but no such stack exists!")
		return

	var just_dropped_item := stack.item
	if not just_dropped_item:
		print("Tried to drop all of stack ID=" + str(stack_id) + " but the stack was empty!")
		return

	remove_stack(stack)

	dropped_item.emit(just_dropped_item, item_stacks)

func get_stack_with_id(id: int) -> ItemStack:
	var valid_stacks := item_stacks.filter(
		func(stack: ItemStack):
			return stack.id == id
	)

	return valid_stacks[0] if valid_stacks.size() > 0 else null

func remove_stack(stack: ItemStack):
	item_stacks = item_stacks.filter(
		func(s: ItemStack):
			return s.id != stack.id
	)

func remove_empty_stacks():
	item_stacks = item_stacks.filter(
		func(stack: ItemStack):
			return stack.amount > 0
	)

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
