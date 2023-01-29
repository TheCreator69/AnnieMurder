extends Control

onready var level_select_0 = $LevelSelect
onready var level_select_1 = $LevelSelect2
onready var level_select_2 = $LevelSelect3
onready var level_select_3 = $LevelSelect4
onready var level_select_4 = $LevelSelect5

func _ready() -> void:
	level_select_0.disabled = Global.is_target_dead(0)
	level_select_1.disabled = Global.is_target_dead(1)
	level_select_2.disabled = Global.is_target_dead(2)
	level_select_3.disabled = Global.is_target_dead(3)
	level_select_4.disabled = not (level_select_0.disabled and level_select_1.disabled and level_select_2.disabled and level_select_3.disabled)

func _on_LevelSelect_pressed() -> void:
	get_tree().change_scene("res://Levels/TestMap.tscn")

func _on_LevelSelect2_pressed() -> void:
	get_tree().change_scene("res://Levels/TestMap.tscn")
