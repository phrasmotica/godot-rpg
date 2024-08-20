extends Node

func _on_bag_added_item(new_item: Item, _item_stacks: Array[ItemStack]):
    Dialogic.VAR.item_name = new_item.name
    Dialogic.start("picked_up_item")
