class_name Bag extends Node

@export
var item_pool: ItemPool

var item_stacks: Array[ItemStack] = []

signal added_item(new_item: Item, items: Array[ItemStack])

func _process(_delta):
	if Input.is_action_just_pressed("random_item"):
		add_random_item()

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
