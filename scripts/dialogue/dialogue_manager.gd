extends Node

signal timeline_started
signal timeline_ended

func _ready():
    Dialogic.timeline_started.connect(handle_timeline_started)
    Dialogic.timeline_ended.connect(handle_timeline_ended)

func start_timeline(timeline: String) -> void:
    if timeline.length() > 0:
        Dialogic.start(timeline)

func handle_timeline_started():
    print("Timeline started!")

    timeline_started.emit()

func handle_timeline_ended():
    print("Timeline ended!")

    timeline_ended.emit()
