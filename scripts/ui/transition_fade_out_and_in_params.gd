class_name TransitionFadeOutAndInParams extends UITransitionParams

@export
var to_colour: Color

func get_shader_type() -> UITransition.Type:
    return UITransition.Type.FADE_OUT_AND_IN

func get_shader_params() -> Dictionary:
    return {
        "duration": duration,
        "to_colour": to_colour,
    }

func get_lifetime() -> float:
    return duration
