extends Node

func _ready() -> void:
	InteractionTransitionsHandler.started.connect(_add)
	ItemTransitionsHandler.started.connect(_add)

func _add(transition: UITransition) -> void:
	add_child(transition)
	transition.owner = self
