extends Control

func _on_StartButton_pressed() -> void:
	$ButtonClick.play()
	SceneTransition.change_scene("res://UI/LevelSelectMenu.tscn")
