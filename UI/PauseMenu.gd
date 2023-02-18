extends Control

onready var button_audio = $ButtonClickAudio

func _on_UnpauseButton_pressed() -> void:
	button_audio.play()
	get_tree().paused = false
	owner._on_pause_change(false)

func _on_KwitButton_pressed() -> void:
	button_audio.play()
	get_tree().paused = false
	owner._on_pause_change(false)
	SceneTransition.change_scene("res://UI/LevelSelectMenu.tscn")
