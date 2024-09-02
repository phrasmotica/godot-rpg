class_name NPC extends CharacterBody2D

@export
var talk_dialogue := "":
    set(value):
        talk_dialogue = value

        if dialogue_area:
            dialogue_area.timeline = talk_dialogue

@onready
var dialogue_area: DialogueArea = %DialogueArea

@onready
var collision_shape: CollisionShape2D = %CollisionShape2D

func _ready():
    collision_shape.shape = dialogue_area.get_area_shape()
