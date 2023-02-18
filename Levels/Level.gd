extends Node2D

var enemies = []
var enemyAlertStates = {}
var player_detected = false

func _ready() -> void:
	var player = get_node("Player")
	player.connect("player_died", self, "_on_player_died")
	
	var children = get_children()
	for child in children:
		if(child.has_method("is_enemy")):
			enemies.append(child)
			child.connect("alert_change", self, "_on_enemy_alert_change")
			enemyAlertStates[child.name] = false

func _on_player_died():
	get_tree().reload_current_scene()

func _on_enemy_alert_change(enemy, alert_state):
	var actualEnemy
	for e in enemies:
		if e == enemy:
			actualEnemy = e
	
	enemyAlertStates[actualEnemy.name] = alert_state
	
	var player = get_node("Player")
	if(enemyAlertStates.values().has(true)):
		player_detected = true
	else:
		player_detected = false

func _process(delta: float) -> void:
	var player = get_node("Player")
	var volume = player.more_music.volume_db
	if player_detected:
		player.more_music.volume_db = lerp(volume, -15, 0.1)
	else:
		player.more_music.volume_db = lerp(volume, -50, 0.01)
