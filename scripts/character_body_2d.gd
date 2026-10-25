extends CharacterBody2D

var speed: float
var flip_interval: float
var tilt_angle: float

var _flip_timer: = 0.0
var _tilt_state: = 1
var is_dead: bool = false 
var _attack_timer: float = 0.0
var _was_attacking: bool = false
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

var span_sound: AudioStream = preload("res://assets/sounds/span.wav")
var land_sound: AudioStream = preload("res://assets/sounds/land.wav")
var punch_sound: AudioStream = preload("res://assets/sounds/punch.wav")
var ded_sound: AudioStream = preload("res://assets/sounds/lil ded.wav")
const ATTACK_INTERVAL := 0.2

func _ready() -> void:
	add_to_group("player")
	
	speed = randf_range(185.0, 215.0)
	flip_interval = randf_range(0.08, 0.18)
	tilt_angle = randf_range(0.08, 0.12)
	_flip_timer = randf_range(0.0, flip_interval)
	_tilt_state = 1 if randf() > 0.5 else -1
	
	sfx_player.stream = span_sound
	sfx_player.play()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = false 
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimatedSprite2D.flip_h = true 
	else:
		velocity.x = move_toward(velocity.x, 0, 50)

	if Input.is_action_pressed("up"):
		velocity.y = -speed
	elif Input.is_action_pressed("down"):
		velocity.y = speed
	else:
		velocity.y = move_toward(velocity.y, 0, 50)
		
	if velocity.length() > 1.0:
		_flip_timer += delta
		if _flip_timer >= flip_interval:
			_flip_timer = 0.0
			_tilt_state = -_tilt_state
			$AnimatedSprite2D.rotation = tilt_angle * _tilt_state
	else:
		_flip_timer = 0.0
		_tilt_state = 1
		$AnimatedSprite2D.rotation = 0.0
			
	if Input.is_action_pressed("attack"):
		$AnimatedSprite2D.play("attack")

		if not _was_attacking:
			_was_attacking = true
			_attack_timer = 0.0
			_deal_attack_damage()
			
	
		_attack_timer += delta
		while _attack_timer >= ATTACK_INTERVAL:
			_attack_timer -= ATTACK_INTERVAL
			_deal_attack_damage()
			

	else:
		_was_attacking = false
		_attack_timer = 0.0
		if $AnimatedSprite2D.animation != "fall":
			$AnimatedSprite2D.play("default")
		
	move_and_slide()

func die() -> void:
	if is_dead:
		return
		
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	$AnimatedSprite2D.play("death")
	
	$CollisionShape2D.set_deferred("disabled", true)
	sfx_player.stream = ded_sound
	sfx_player.play()


func _deal_attack_damage() -> void:
	for body in $attackArea.get_overlapping_bodies():
		if body.is_in_group("dino") and body.has_method("damage"):
			body.damage()
			sfx_player.stream = punch_sound
			sfx_player.play()
