extends CanvasLayer

func change_scene(target: String) -> void:
	$DissolvePlayer.play("Dissolve")
	yield($DissolvePlayer, "animation_finished")
	get_tree().change_scene(target)
	$DissolvePlayer.play_backwards("Dissolve")
