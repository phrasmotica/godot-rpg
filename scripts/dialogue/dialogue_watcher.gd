extends Node

@export
var dialogue_manager: DialogueManager

@export
var target: Node

# func _ready():
#     if dialogue_manager:
#         dialogue_manager.timeline_started.connect(handle_timeline_started)
#         dialogue_manager.timeline_ended.connect(handle_timeline_ended)

func handle_timeline_started():
    if target:
        print("DialogueWatcher preventing input on " + target.name)

        target.set_process(false)

func handle_timeline_ended():
    if target:
        print("DialogueWatcher allowing input on " + target.name)

        # this ensures the target processes again from the NEXT frame
        var callable := target.set_process.bind(true)
        get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)
