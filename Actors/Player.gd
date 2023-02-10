extends KinematicBody2D

# TODO: Add camera to player, so player is at center of screen

var speed = 350
var jump_speed = 775
var gravity = 20
var max_gravity = 500
var velocity = Vector2()
var facing_left = false

var coyote_time = 0
var jump_buffer_time = 0
var was_on_floor = is_on_floor()

onready var flipper = $Flipper
onready var murder_detection = $Flipper/MurderDetection
onready var camera = $Camera2D
onready var pause_menu = $PauseMenu

onready var jump_audio = $JumpAudio
onready var stabby_audio = $StabbyAudio
onready var footstep_audio = $FootstepAudio

signal player_died

func _ready() -> void:
	pause_menu.owner = self

func _input(event):
	if event.is_action_pressed("left"):
		if !facing_left:
			flipper.scale.x = -1
			facing_left = true
	elif event.is_action_pressed("right"):
		if facing_left:
			flipper.scale.x = 1
			facing_left = false
	elif event.is_action_pressed("murder"):
		if(murder_detection.is_colliding()):
			var enemy = murder_detection.get_collider()
			if enemy.has_method("is_enemy") and is_instance_valid(enemy):
				enemy.attempt_kill()
				stabby_audio.play()
			elif enemy.has_method("is_target") and is_instance_valid(enemy):
				enemy.kill()
				stabby_audio.play()
	elif event.is_action_pressed("pause"):
		_on_pause_change(true)
		get_tree().paused = true

func _set_velocity():
	if is_on_ceiling():
		velocity.y = 0
	if not is_on_floor():
		velocity.y += gravity
		velocity.y = min(velocity.y, max_gravity)
		# TODO: Allow player to stick to ceiling?
	else:
		velocity.y = 5 # >0 so player is always colliding with floor (used for is_on_floor())
	
	if !was_on_floor and is_on_floor():
		if jump_buffer_time > 0:
			velocity.y = -jump_speed
			jump_buffer_time = 0
			jump_audio.play()
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_time <= 0.25:
			velocity.y = -jump_speed
			jump_audio.play()
		else:
			jump_buffer_time = 0.15
		
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		if !footstep_audio.playing and is_on_floor():
			footstep_audio.play()
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		if !footstep_audio.playing and is_on_floor():
			footstep_audio.play()
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
		footstep_audio.stop()

func _set_lookahead():
	if facing_left:
		camera.offset_h = lerp(camera.offset_h, -0.5, 0.05)
	else:
		camera.offset_h = lerp(camera.offset_h, 0.5, 0.05)

func _set_koyote_time(delta):
	if is_on_floor():
		coyote_time = 0
	else:
		coyote_time += delta

func _set_jump_buffer_time(delta):
	jump_buffer_time -= delta

func _physics_process(delta):
	_set_koyote_time(delta)
	_set_jump_buffer_time(delta)
	_set_velocity()
	_set_lookahead()
	was_on_floor = is_on_floor()
	move_and_slide(velocity, Vector2.UP)

func kill():
	emit_signal("player_died")

func _on_pause_change(paused):
	if paused:
		pause_menu.visible = true
	else:
		pause_menu.visible = false

func is_player():
	return false
