extends Node2D


func _ready() -> void:
	var player = get_node("Player")
	player.connect("player_died", self, "_on_player_died")

func _on_player_died():
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	pass
