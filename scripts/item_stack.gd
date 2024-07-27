class_name ItemStack extends Resource

@export
var id := -1

@export
var item: Item

@export
var amount := 0

func will_accept(new_item: Item):
	if amount <= 0:
		return true

	if item.id != new_item.id:
		return false

	return item.same_meta_as(new_item)

func push(new_item: Item):
	if will_accept(new_item):
		item = new_item
		amount += 1

func drop(x: int) -> Item:
	if amount <= 0:
		return null

	amount = max(0, amount - x)

	var dropped_item := item

	if amount <= 0:
		item = null

	return dropped_item
