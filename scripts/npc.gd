class_name NPC extends CharacterBody2D

@export
var talk_dialogue := ""

signal talked(dialogue_timeline: String)

func _ready():
    get_tree().process_frame.connect(talk, CONNECT_ONE_SHOT)

func talk():
    if talk_dialogue.length() > 0:
        talked.emit(talk_dialogue)
