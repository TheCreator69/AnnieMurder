extends Node2D

export var level_to_transition_to = "res://Levels/TestMap.tscn"

func _on_Trigger_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.has_method("is_player"):
		SceneTransition.change_scene(level_to_transition_to)
