class_name ItemArea extends Area2D

signal player_is_looking

func player_looking():
    player_is_looking.emit()
