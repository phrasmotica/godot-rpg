class_name DialogueArea extends Area2D

@export
var timeline := ""

@onready
var collision_shape: CollisionShape2D = %CollisionShape2D

func get_area_shape():
    return collision_shape.shape
