class_name Bag extends Node

@export
var item_pool: ItemPool

var item_stacks: Array[ItemStack] = []

signal added_item(new_item: Item, item_stacks: Array[ItemStack])
signal dropped_item(dropped_item: Item, item_stacks: Array[ItemStack])

signal drop_item

func _process(_delta):
	if Input.is_action_just_pressed("random_item"):
		add_random_item()

	if Input.is_action_just_pressed("drop_item"):
		drop_item.emit()

func add_random_item():
	var new_item := item_pool.get_random()
	add_item(new_item)

func add_item(new_item: Item):
	var existing_stack := find_stack(new_item)

	if existing_stack:
		print("Pushing " + new_item.name + " to stack ID " + str(existing_stack.id))

		existing_stack.push(new_item)
	else:
		print("Creaating new stack for " + new_item.name)

		var new_stack = ItemStack.new()
		new_stack.id = item_stacks.size()

		new_stack.push(new_item)
		item_stacks.append(new_stack)

	added_item.emit(new_item, item_stacks)

func find_stack(new_item: Item) -> ItemStack:
	var valid_stacks := item_stacks.filter(
		func(stack: ItemStack):
			return stack.will_accept(new_item)
	)

	return valid_stacks[0] if valid_stacks.size() > 0 else null

func _on_bag_menu_drop_item(stack_id: int):
	var valid_stacks := item_stacks.filter(
		func(stack: ItemStack):
			return stack.id == stack_id
	)

	if valid_stacks.size() <= 0:
		print("Tried to drop from stack ID=" + str(stack_id) + " but no such stack exists!")
		return

	var drop_stack: ItemStack = valid_stacks[0]

	var just_dropped_item := drop_stack.drop(1)
	if  not just_dropped_item:
		print("Tried to drop from stack ID=" + str(stack_id) + " but the stack was empty!")
		return

	print("Dropped from stack ID=" + str(stack_id))

	# remove empty stacks
	item_stacks = item_stacks.filter(
		func(stack: ItemStack):
			return stack.amount > 0
	)

	dropped_item.emit(just_dropped_item, item_stacks)
