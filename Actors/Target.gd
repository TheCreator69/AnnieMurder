extends Node2D

export var target_index = 0
export var target_skin: Texture
export var skin_scale = Vector2(0.1, 0.1)

onready var sprite = $Sprite

func _ready() -> void:
	if target_skin != null:
		sprite.texture = target_skin
		sprite.scale = skin_scale

func kill():
	Global.target_killed(target_index)
	if target_index == 3:
		SceneTransition.change_scene("res://UI/OutroStory.tscn")
	else:
		SceneTransition.change_scene("res://UI/LevelSelectMenu.tscn")

func is_target():
	return 0
