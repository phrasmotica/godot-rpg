@tool
class_name PlayerAppearance
extends Node

@export
var sprite: AnimatedSprite2D

func update_colours(torso_colour: Color, sleeve_colour: Color) -> void:
	if sprite:
		var shader := sprite.material as ShaderMaterial
		shader.set_shader_parameter("torso_colour", torso_colour)
		shader.set_shader_parameter("sleeve_colour", sleeve_colour)

func moving_finished() -> void:
	if sprite:
		sprite.stop()
