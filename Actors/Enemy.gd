extends KinematicBody2D

var player = null

var speed = 200
var velocity = Vector2(speed, 0)
# TODO: Export this variable for better control for level designers: which way do enemies start off?
export var facing_left = false

onready var vision = $Vision
onready var floorDetector = $FloorDetector
onready var shotTimer = $ShotTimer
onready var searchTimer = $SearchTimer
onready var bulletSpawnPos = $BulletSpawnPosition

var Bullet = preload("res://Actors/Bullet.tscn")
onready var gunshot_audio = $GunshotAudio

enum State {
	PATROLLING,
	SEARCHING,
	CHASING
}
var enemyState = State.PATROLLING

var timeBetweenShots = 1
var searchTime = 5

func _ready() -> void:
	if facing_left:
		scale.x = -scale.x
		velocity.x = -velocity.x
	
func _move_around():
	match enemyState:
		State.PATROLLING:
			if is_on_wall() or not floorDetector.is_colliding():
				velocity.x = -velocity.x
				scale.x = -scale.x
				facing_left = not facing_left
		State.SEARCHING:
			if is_on_wall() or not floorDetector.is_colliding():
				velocity.x = -velocity.x
				scale.x = -scale.x
				facing_left = not facing_left
		State.CHASING:
			if is_on_wall() or not floorDetector.is_colliding():
				velocity.x = 0
		_:
			pass

func _switch_state(new_state):
	print(State.keys()[new_state])
	enemyState = new_state
	match new_state:
		State.PATROLLING:
			speed = 100
			velocity.x = -speed if facing_left else speed
			vision.scale = Vector2(1, 1)
		State.SEARCHING:
			speed = 200
			velocity.x = -speed if facing_left else speed
			vision.scale = Vector2(2, 2)
		State.CHASING:
			speed = 250
			velocity.x = -speed if facing_left else speed
			vision.scale = Vector2(2, 2)
		_:
			pass

func _physics_process(delta):
	_move_around()
	move_and_slide(velocity, Vector2.UP)

func _on_Vision_area_entered(area: Area2D) -> void:
	var spaceState = get_world_2d().direct_space_state
	
	var rayCastResult = spaceState.intersect_ray(global_position, area.global_position, [self])
	var collider = rayCastResult.get("collider")
	
	if collider.has_method("is_player"):
		player = collider
		_switch_state(State.CHASING)
		shotTimer.start(timeBetweenShots)
		searchTimer.stop()

func _on_Vision_area_exited(area: Area2D) -> void:
	if area.get_parent().has_method("is_player") and enemyState == State.CHASING:
		_switch_state(State.SEARCHING)
		searchTimer.start(searchTime)
		shotTimer.stop()
		player = null

func _on_ShotTimer_timeout() -> void:
	if player != null:
		shoot()
		gunshot_audio.play()

func shoot() -> void:
	var bullet = Bullet.instance()
	var vectorToPlayer = player.global_position - global_position
	bullet.fire(bulletSpawnPos.global_position, vectorToPlayer.normalized())
	get_tree().current_scene.add_child(bullet) # Add bullet to level

func _on_SearchTimer_timeout() -> void:
	_switch_state(State.PATROLLING)

func attempt_kill():
	if enemyState != State.CHASING:
		queue_free()

func is_enemy():
	return "Chicken"
