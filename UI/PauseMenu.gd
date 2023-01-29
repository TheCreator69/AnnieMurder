extends Control


func _ready() -> void:
	pass # Replace with function body.

#func _process(delta: float) -> void:
#	pass

func _on_UnpauseButton_pressed() -> void:
	get_tree().paused = false
	owner._on_pause_change(false)

func _on_KwitButton_pressed() -> void:
	get_tree().change_scene("res://UI/LevelSelectMenu.tscn")
	# TODO: Won't let me select level afterwards
