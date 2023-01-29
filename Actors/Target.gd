extends Node2D

export var target_index = 0

func kill():
	Global.target_killed(target_index)
	get_tree().change_scene("res://UI/LevelSelectMenu.tscn")

func is_target():
	return 0
