class_name UITransitionParams extends Resource

@export_range(0.1, 10.0)
var duration: float

func get_shader_type() -> UITransition.Type:
    return 0 as UITransition.Type

func get_shader_params() -> Dictionary:
    return {}
