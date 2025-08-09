class_name NextFrameHandler extends Node

# TODO: replace this with an autoload SignalHelper

func on_next_frame(callable: Callable) -> void:
    get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)
