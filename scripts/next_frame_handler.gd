class_name NextFrameHandler extends Node

func on_next_frame(callable: Callable) -> void:
    get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)
