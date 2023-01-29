extends KinematicBody2D

# TODO: Add camera to player, so player is at center of screen

var speed = 350
var jumpSpeed = 775
var gravity = 20
var maxGravity = 500
var velocity = Vector2()
var facing_left = false

var coyoteTime = 0
var jumpBufferTime = 0
var was_on_floor = is_on_floor()

onready var murderDetection = $MurderDetection
onready var camera = $Camera2D

signal player_died

func _ready() -> void:
	pass

func _input(event):
	if event.is_action_pressed("left"):
		if !facing_left:
			scale.x = -1
			facing_left = true
	elif event.is_action_pressed("right"):
		if facing_left:
			scale.x = -1
			facing_left = false
	elif event.is_action_pressed("murder"):
		if(murderDetection.is_colliding()):
			var firstEnemy = murderDetection.get_collider()
			if firstEnemy.has_method("is_enemy") and is_instance_valid(firstEnemy):
				firstEnemy.queue_free()

func _set_velocity():
	if not is_on_floor():
		velocity.y += gravity
		velocity.y = min(velocity.y, maxGravity)
		# TODO: Allow player to stick to ceiling?
	else:
		velocity.y = 5 # >0 so player is always colliding with floor (used for is_on_floor())
	
	if !was_on_floor and is_on_floor():
		if jumpBufferTime > 0:
			velocity.y = -jumpSpeed
			jumpBufferTime = 0
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyoteTime <= 0.25:
			velocity.y = -jumpSpeed
			# TODO: Allow player to hold down jump button for a bit for higher jump?
		else:
			jumpBufferTime = 0.15
		
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	elif Input.is_action_pressed("right"):
		velocity.x = speed
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)

func _set_lookahead():
	if facing_left:
		camera.offset_h = lerp(camera.offset_h, -0.5, 0.05)
	else:
		camera.offset_h = lerp(camera.offset_h, 0.5, 0.05)

func _set_koyote_time(delta):
	if is_on_floor():
		coyoteTime = 0
	else:
		coyoteTime += delta

func _set_jump_buffer_time(delta):
	jumpBufferTime -= delta

func _physics_process(delta):
	_set_koyote_time(delta)
	_set_jump_buffer_time(delta)
	_set_velocity()
	_set_lookahead()
	was_on_floor = is_on_floor()
	move_and_slide(velocity, Vector2.UP)

func kill():
	emit_signal("player_died")

func is_player():
	return false
