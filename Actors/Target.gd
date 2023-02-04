extends Node2D

export var target_index = 0
export var target_skin: Texture

onready var sprite = $Sprite

func _ready() -> void:
	if target_skin != null:
		sprite.texture = target_skin

func kill():
	Global.target_killed(target_index)
	get_tree().change_scene("res://UI/LevelSelectMenu.tscn")

func is_target():
	return 0
