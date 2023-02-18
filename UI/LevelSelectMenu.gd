extends Control

onready var level_select_1 = $LevelSelect1
onready var level_select_2 = $LevelSelect2
onready var level_select_3 = $LevelSelect3
onready var level_select_4 = $LevelSelect4

onready var creator = $LevelSelect4/CreatorIcon

onready var skull_1 = $LevelSelect1/Skull1
onready var skull_2 = $LevelSelect2/Skull2
onready var skull_3 = $LevelSelect3/Skull3
onready var skull_4 = $LevelSelect4/Skull4

onready var button_audio = $ButtonClickAudio

func _ready() -> void:
	level_select_1.disabled = Global.is_target_dead(0)
	skull_1.visible = Global.is_target_dead(0)
	level_select_2.disabled = Global.is_target_dead(1)
	skull_2.visible = Global.is_target_dead(1)
	level_select_3.disabled = Global.is_target_dead(2)
	skull_3.visible = Global.is_target_dead(2)
	
	var creatorLocked = not (level_select_1.disabled and level_select_2.disabled and level_select_3.disabled)
	level_select_4.disabled = creatorLocked
	skull_4.visible = Global.is_target_dead(3)
	creator.visible = not creatorLocked
	
func _on_LevelSelect_pressed() -> void:
	button_audio.play()
	SceneTransition.change_scene("res://Levels/TargetLevel0.tscn")

func _on_LevelSelect2_pressed() -> void:
	button_audio.play()
	SceneTransition.change_scene("res://Levels/TargetLevel1.tscn")

func _on_LevelSelect3_pressed() -> void:
	button_audio.play()
	SceneTransition.change_scene("res://Levels/TargetLevel2.tscn")

func _on_LevelSelect4_pressed() -> void:
	button_audio.play()
	SceneTransition.change_scene("res://Levels/TargetLevel3.tscn")
