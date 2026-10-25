extends CharacterBody2D

var speed: = 120
var flip_interval: float
var tilt_angle: float
var _flip_timer: = 0.0
var _tilt_state: = 1
var random: = 50
var health: = 100
var is_dead: bool = false  

@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	add_to_group("big-guy")
	
	flip_interval = randf_range(0.15, 0.25)
	
	tilt_angle = randf_range(0.08, 0.12)
	
	_flip_timer = randf_range(0.0, flip_interval)
	
	_tilt_state = 1 if randf() > 0.5 else -1
	
	update_health_bar()
func _physics_process(delta: float) -> void:
	if randf_range(1.0, 300) < 5:
		random = randf_range(1.0, 100.0)
	if random < 20:
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = false 
	elif random < 40:
		velocity.x = speed
		$AnimatedSprite2D.flip_h = true 
	else:
		velocity.x = move_toward(velocity.x, 0, 50)

	if random > 80:
		velocity.y = -speed
	elif random > 60:
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
			
	move_and_slide()
	
	if health < 1:
		if is_dead:
			return
		is_dead = true
		velocity = Vector2.ZERO
		set_physics_process(false)
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://ded.tscn")

func damage():
	health -= 20
	update_health_bar()
	
func update_health_bar():
	if is_instance_valid(health_bar):
		health_bar.value = health
	
