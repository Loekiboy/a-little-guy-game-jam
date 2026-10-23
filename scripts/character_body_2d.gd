extends CharacterBody2D

const SPEED = 300.0
const FLIP_INTERVAL := 0.2 
const TILT_ANGLE := 0.1

var _flip_timer := 0.0
var _tilt_state := 1

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite2D.flip_h = false 
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite2D.flip_h = true 
	else:
		velocity.x = move_toward(velocity.x, 0, 50)

	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, 50)
		
	if velocity.length() > 1.0:
		_flip_timer += delta
		if _flip_timer >= FLIP_INTERVAL:
			_flip_timer = 0.0
			_tilt_state = -_tilt_state
			$Sprite2D.rotation = TILT_ANGLE * _tilt_state
	else:
		_flip_timer = 0.0
		_tilt_state = 1
		$Sprite2D.rotation = 0.0
			
	move_and_slide()
