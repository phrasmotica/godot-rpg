class_name UITransitionFactory

var _ui_transition_scene := preload("res://scenes/ui/ui_transition.tscn")

func create(params: UITransitionParams) -> UITransition:
    var transition: UITransition = _ui_transition_scene.instantiate()
    transition.inject(params)

    return transition
