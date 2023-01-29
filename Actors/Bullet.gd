extends Node2D

var _velocity = Vector2.ZERO
var speed = 400

func _ready() -> void:
	pass

func fire(start_pos, direction: Vector2):
	_velocity = direction * speed
	global_position = start_pos
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += _velocity * delta

func _on_HitDetection_area_entered(area: Area2D) -> void:
	print("Hit!")
	var player = area.get_parent()
	if player.has_method("is_player"):
		player.kill()
