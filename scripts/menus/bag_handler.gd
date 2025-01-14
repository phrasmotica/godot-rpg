class_name BagHandler extends Node

signal bag_changed(item_stacks: Array[ItemStack])

func handle_bag_added_item(new_item: Item, _altered: bool, _silent: bool, item_stacks: Array[ItemStack]) -> void:
	print("Added " + new_item.name + " to bag")

	bag_changed.emit(item_stacks)

func handle_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Dropped " + dropped_item.name + " from bag")

	bag_changed.emit(item_stacks)

func handle_bag_used_item(used_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Used " + used_item.name + " from bag")

	bag_changed.emit(item_stacks)

func handle_bag_consumed_item(consumed_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Consumed " + consumed_item.name + " from bag")

	bag_changed.emit(item_stacks)
