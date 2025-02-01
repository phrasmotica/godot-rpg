class_name UITransitionFactory extends Node

@onready
var ui_transition_scene: PackedScene = load("res://scenes/ui/ui_transition.tscn")

func create(params: UITransitionParams) -> UITransition:
    var transition: UITransition = ui_transition_scene.instantiate()
    transition.inject(params)

    add_child(transition)
    transition.owner = self

    return transition
