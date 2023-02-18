extends Control

func _on_YouTubePlayButton_pressed() -> void:
	$ButtonClick.play()
	SceneTransition.change_scene("res://UI/IntroStory.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
