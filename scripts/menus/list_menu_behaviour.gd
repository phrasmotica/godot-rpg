@tool
class_name ListMenu extends Node

@export
var items: Array[MenuItem] = []

@onready
var index_handler: ListIndexHandler = %ListIndexHandler

signal select_index(index: int)

func _ready() -> void:
	index_handler.current_index_changed.connect(_handle_current_index_changed)

	if items.size() > 0:
		index_handler.update(0)

func _handle_current_index_changed(_index: int) -> void:
	_highlight_current()

func _highlight_current() -> void:
	for i in items.size():
		items[i].selected = i == index_handler.current

func item() -> MenuItem:
	return items[index_handler.current]

func next() -> void:
	if items.size() <= 0:
		return

	index_handler.update((index_handler.current + 1) % items.size())

func previous() -> void:
	if items.size() <= 0:
		return

	index_handler.update((index_handler.current + items.size() - 1) % items.size())

func next_if_disabled() -> void:
	while items[index_handler.current].disabled:
		next()

func select_current() -> void:
	select_index.emit(index_handler.current)
