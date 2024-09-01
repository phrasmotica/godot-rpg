extends Node2D

@export
var npcs: Array[NPC] = []

signal npc_talked(dialogue_timeline: String)

func _ready():
    for n in npcs:
        n.talked.connect(on_npc_talked)

func on_npc_talked(dialogue_timeline: String):
    if dialogue_timeline.length() > 0:
        print("Playing " + dialogue_timeline + " dialogue")

        npc_talked.emit(dialogue_timeline)
