extends CharacterBody2D

var speed: float
var flip_interval: float
var tilt_angle: float

var _flip_timer := 0.0
var _tilt_state := 1

func _ready() -> void:
	speed = randf_range(285.0, 315.0)
	
	flip_interval = randf_range(0.15, 0.25)
	
	tilt_angle = randf_range(0.08, 0.12)
	
	_flip_timer = randf_range(0.0, flip_interval)
	
	_tilt_state = 1 if randf() > 0.5 else -1

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
			
	move_and_slide()
