class_name UseItemMenuStateData

var _stack: ItemStack = null

static func build() -> UseItemMenuStateData:
	return UseItemMenuStateData.new()

func with_stack(stack: ItemStack) -> UseItemMenuStateData:
	_stack = stack
	return self

func get_stack() -> ItemStack:
	return _stack
