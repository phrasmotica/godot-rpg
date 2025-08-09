@tool
class_name UseItemMenuItem extends MenuItem

@export
var action: UseItemMenuBehaviour.UseItemAction

func _ready() -> void:
	_refresh()
