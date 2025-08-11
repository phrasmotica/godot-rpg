class_name StackManager

var _item_stacks: Array[ItemStack] = []

func get_stacks() -> Array[ItemStack]:
	return _item_stacks

func add_item(item: Item) -> Item:
	# ensures that changing a meta value on this item does NOT change
	# said meta value on all other instances of the item
	var new_item: Item = item.duplicate()

	var existing_stack := find_stack(new_item)

	if existing_stack:
		print("Pushing %s to stack ID %d" % [new_item.name, existing_stack.get_id()])

		existing_stack.push(new_item)
	else:
		print("Creating new stack for %s" % new_item.get_display_name())

		var max_id: int = _item_stacks.map(func(s): return s.get_id()).max() or 1

		var new_stack := ItemStack.new(max_id)
		new_stack.push(new_item)

		_item_stacks.append(new_stack)

	return new_item

func peek(stack_id: int) -> Item:
	var stack := get_stack_with_id(stack_id)

	if not stack:
		print("Tried to peek from stack ID=" + str(stack_id) + " but no such stack exists!")
		return null

	var item := stack.get_item()

	if not item or stack.get_amount() < 1:
		print("Tried to peek from stack ID=" + str(stack_id) + " but the stack was empty!")
		return null

	return stack.peek()

func drop_item(stack_id: int, cleanup := false) -> Item:
	var stack := get_stack_with_id(stack_id)

	if not stack:
		print("Tried to drop from stack ID=" + str(stack_id) + " but no such stack exists!")
		return null

	var just_dropped_item := stack.drop(1)
	if not just_dropped_item:
		print("Tried to drop from stack ID=" + str(stack_id) + " but the stack was empty!")
		return null

	print("Dropped from stack ID=" + str(stack_id))

	if cleanup:
		remove_empty_stacks()

	return just_dropped_item

func drop_stack(stack_id: int) -> Item:
	var stack := get_stack_with_id(stack_id)

	if not stack:
		print("Tried to drop all of stack ID=" + str(stack_id) + " but no such stack exists!")
		return null

	var just_dropped_item := stack.get_item()
	if not just_dropped_item:
		print("Tried to drop all of stack ID=" + str(stack_id) + " but the stack was empty!")
		return null

	remove_stack(stack)

	return just_dropped_item

func find_stack(new_item: Item) -> ItemStack:
	var valid_stacks := _item_stacks.filter(
		func(stack: ItemStack):
			return stack.will_accept(new_item)
	)

	return valid_stacks[0] if valid_stacks.size() > 0 else null

func get_stack_with_id(id: int) -> ItemStack:
	var valid_stacks := _item_stacks.filter(
		func(stack: ItemStack):
			return stack.get_id() == id
	)

	return valid_stacks[0] if valid_stacks.size() > 0 else null

func remove_stack(stack: ItemStack) -> void:
	_item_stacks = _item_stacks.filter(
		func(s: ItemStack):
			return s.get_id() != stack.get_id()
	)

func remove_empty_stacks() -> void:
	_item_stacks = _item_stacks.filter(
		func(stack: ItemStack):
			return stack.get_amount() > 0
	)
