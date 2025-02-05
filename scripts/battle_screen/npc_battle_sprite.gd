@tool
class_name NPCBattleSprite extends Sprite2D

enum SpriteMode { NORMAL, TAKE_DAMAGE }

@export
var mode: SpriteMode:
	set(value):
		mode = value

		_refresh()

		if mode != SpriteMode.NORMAL:
			# reset after a short delay
			await get_tree().create_timer(1.0).timeout
			mode = SpriteMode.NORMAL

@export_group("Shaders")

@export
var take_damage_shader: Shader

func _refresh() -> void:
	(material as ShaderMaterial).shader = _compute_shader()

func _compute_shader() -> Shader:
	if mode == SpriteMode.TAKE_DAMAGE:
		return take_damage_shader

	return null
