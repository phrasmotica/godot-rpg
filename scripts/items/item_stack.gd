class_name ItemStack

var _id := -1
var _item: Item = null
var _amount := 0

func _init(id: int) -> void:
	_id = id

func get_id() -> int:
	return _id

func get_item() -> Item:
	return _item

func get_amount() -> int:
	return _amount

func will_accept(new_item: Item):
	if _amount <= 0:
		return true

	if _item.id != new_item.id:
		return false

	return _item.same_meta_as(new_item)

func push(new_item: Item):
	if will_accept(new_item):
		_item = new_item
		_amount += 1

func drop(x: int) -> Item:
	if _amount <= 0:
		return null

	_amount = max(0, _amount - x)

	var dropped_item := _item

	if _amount <= 0:
		_item = null

	return dropped_item
