extends KinematicBody2D

signal alert_change(enemy, is_alert)

var player = null

var speed = 100
var velocity = Vector2(speed, 0)
export var facing_left = false

onready var vision = $Vision
onready var floor_detector = $FloorDetector
onready var shot_timer = $ShotTimer
onready var search_timer = $SearchTimer
onready var bullet_spawn_pos = $BulletSpawnPosition

var Bullet = preload("res://Actors/Bullet.tscn")
onready var gunshot_audio = $GunshotAudio

enum State {
	PATROLLING,
	SEARCHING,
	CHASING
}
var enemy_state = State.PATROLLING

var time_between_shots = 0.5
var search_time = 5

func _ready() -> void:
	if facing_left:
		scale.x = -scale.x
		velocity.x = -velocity.x
	
func _move_around():
	match enemy_state:
		State.PATROLLING:
			if is_on_wall() or not floor_detector.is_colliding():
				velocity.x = -velocity.x
				scale.x = -scale.x
				facing_left = not facing_left
		State.SEARCHING:
			if is_on_wall() or not floor_detector.is_colliding():
				velocity.x = -velocity.x
				scale.x = -scale.x
				facing_left = not facing_left
		State.CHASING:
			if is_on_wall() or not floor_detector.is_colliding():
				velocity.x = 0
		_:
			pass

func _switch_state(new_state):
	enemy_state = new_state
	match new_state:
		State.PATROLLING:
			speed = 100
			velocity.x = -speed if facing_left else speed
			vision.scale = Vector2(1, 1)
			emit_signal("alert_change", self, false)
		State.SEARCHING:
			speed = 150
			velocity.x = -speed if facing_left else speed
			vision.scale = Vector2(2, 2)
		State.CHASING:
			speed = 250
			velocity.x = -speed if facing_left else speed
			vision.scale = Vector2(2, 2)
			emit_signal("alert_change", self, true)
		_:
			pass

func _physics_process(delta):
	_move_around()
	move_and_slide(velocity, Vector2.UP)

func _on_Vision_area_entered(area: Area2D) -> void:
	var space_state = get_world_2d().direct_space_state
	
	var ray_cast_result = space_state.intersect_ray(global_position, area.global_position, [self])
	var collider = ray_cast_result.get("collider")
	
	if collider.has_method("is_player"):
		player = collider
		if enemy_state == State.SEARCHING:
			shoot()
		_switch_state(State.CHASING)
		shot_timer.start(time_between_shots)
		search_timer.stop()

func _on_Vision_area_exited(area: Area2D) -> void:
	if area.get_parent().has_method("is_player") and enemy_state == State.CHASING:
		_switch_state(State.SEARCHING)
		search_timer.start(search_time)
		shot_timer.stop()
		player = null

func _on_ShotTimer_timeout() -> void:
	if player != null:
		shoot()
		gunshot_audio.play()

func shoot() -> void:
	var bullet = Bullet.instance()
	var vector_to_player = player.global_position - global_position
	bullet.fire(bullet_spawn_pos.global_position, vector_to_player.normalized())
	get_tree().current_scene.add_child(bullet) # Add bullet to level

func _on_SearchTimer_timeout() -> void:
	_switch_state(State.PATROLLING)

func attempt_kill():
	if enemy_state != State.CHASING:
		emit_signal("alert_change", self, false)
		queue_free()

func is_enemy():
	return "Chicken"
