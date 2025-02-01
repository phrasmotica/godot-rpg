class_name TransitionFadeOutParams extends UITransitionParams

@export
var to_colour: Color

func get_shader_type() -> UITransition.Type:
    return UITransition.Type.FADE_OUT

func get_shader_params() -> Dictionary:
    return {
        "duration": duration,
        "to_colour": to_colour,
    }

func get_lifetime() -> float:
    return duration
