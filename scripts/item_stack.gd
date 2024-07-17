class_name ItemStack extends Resource

@export
var id := -1

@export
var item: Item

@export
var amount := 0

func will_accept(new_item: Item):
	return amount <= 0 || (item and new_item.id == item.id)

func push(new_item: Item):
	if will_accept(new_item):
		item = new_item
		amount += 1
