class_name Bag extends Node

@export
var player: Player

@export
var item_consumer: ItemConsumer

@export
var bag_menu: BagMenu

@onready
var stack_manager: StackManager = %StackManager

signal added_item(new_item: Item, altered: bool, item_stacks: Array[ItemStack])
signal dropped_item(dropped_item: Item, item_stacks: Array[ItemStack])
signal used_item(used_item: Item, item_stacks: Array[ItemStack])
signal consumed_item(consumed_item: Item, item_stacks: Array[ItemStack])

func _ready():
	if player:
		player.pickup_item.connect(_handle_player_pickup_item)

	if bag_menu:
		bag_menu.use_item.connect(_try_use_item)
		bag_menu.drop_item.connect(_drop_item)
		bag_menu.drop_stack.connect(_drop_stack)

func _handle_player_pickup_item(item: Item) -> void:
	print("Player picked up " + item.name)

	_add_item(item)

func _add_item(item: Item) -> void:
	var new_item = stack_manager.add_item(item)

	added_item.emit(new_item, false, stack_manager.get_stacks())

func _try_use_item(stack_id: int) -> void:
	var item := stack_manager.peek(stack_id)

	if not item:
		print("Tried to use from stack ID=" + str(stack_id) + " but no item was found!")
		return

	var can_consume := item_consumer.can_consume(item)

	var did_use := item_consumer.use(item)
	if not did_use:
		print("Did not use item " + item.name)
		return

	# take the item off the stack, we might put it back in the bag later
	stack_manager.drop_item(stack_id)
	print("Used " + item.name + " from stack ID=" + str(stack_id))

	used_item.emit(item, stack_manager.get_stacks())

	if not can_consume:
		# we might be able to consume the item now, as its list of external
		# effects might have changed, but we require the player to use it from
		# the bag again to do this
		_put_back(item)

		print(item.name + " could not be consumed before its use")
		return

	var did_consume := item_consumer.consume(item)
	if not did_consume:
		# add the item back in its possibly altered state after being used
		_put_back(item)

		print("Did not consume item " + item.name)
		return

	print("Consumed " + item.name + " from stack ID=" + str(stack_id))

	stack_manager.remove_empty_stacks()

	consumed_item.emit(item, stack_manager.get_stacks())

func _put_back(item: Item) -> void:
	var altered_item := stack_manager.add_item(item)
	stack_manager.remove_empty_stacks()

	added_item.emit(altered_item, true, stack_manager.get_stacks())

func _drop_item(stack_id: int) -> void:
	var just_dropped_item := stack_manager.drop_item(stack_id, true)

	dropped_item.emit(just_dropped_item, stack_manager.get_stacks())

func _drop_stack(stack_id: int) -> void:
	var just_dropped_item := stack_manager.drop_stack(stack_id)

	dropped_item.emit(just_dropped_item, stack_manager.get_stacks())
