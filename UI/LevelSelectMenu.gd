extends Control

onready var level_select_0 = $LevelSelect
onready var level_select_1 = $LevelSelect2
onready var level_select_2 = $LevelSelect3
onready var level_select_4 = $LevelSelect5

onready var button_audio = $ButtonClickAudio

func _ready() -> void:
	level_select_0.disabled = Global.is_target_dead(0)
	level_select_1.disabled = Global.is_target_dead(1)
	level_select_2.disabled = Global.is_target_dead(2)
	level_select_4.disabled = not (level_select_0.disabled and level_select_1.disabled and level_select_2.disabled)

func _on_LevelSelect_pressed() -> void:
	button_audio.play()
	get_tree().change_scene("res://Levels/TestMap.tscn")

func _on_LevelSelect2_pressed() -> void:
	button_audio.play()
	get_tree().change_scene("res://Levels/TestMap.tscn")

func _on_LevelSelect3_pressed() -> void:
	button_audio.play()
	get_tree().change_scene("res://Levels/TestMap.tscn")

func _on_LevelSelect5_pressed() -> void:
	button_audio.play()
	get_tree().change_scene("res://Levels/TestMap.tscn")
