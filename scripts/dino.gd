extends CharacterBody2D

var speed: = 120
var flip_interval: float
var tilt_angle: float
var _flip_timer: = 0.0
var _tilt_state: = 1
var random: = 50
var is_attacking: bool = false 

func _ready() -> void:
	flip_interval = randf_range(0.15, 0.25)
	tilt_angle = randf_range(0.08, 0.12)
	_flip_timer = randf_range(0.0, flip_interval)
	_tilt_state = 1 if randf() > 0.5 else -1
	
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.rotation = 0.0 
		move_and_slide()
		return 

	if randf_range(1.0, 300) < 5:
		random = randf_range(1.0, 100.0)
		
	if random < 20:
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = false 
		$AttackArea.scale.x = 1
		$DamageArea.scale.x = 1
		
	elif random < 40:
		velocity.x = speed
		$AnimatedSprite2D.flip_h = true 
		$AttackArea.scale.x = -1
		$DamageArea.scale.x = -1
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
			
			var flip_multiplier = -1 if $AnimatedSprite2D.flip_h else 1
			$AnimatedSprite2D.rotation = tilt_angle * _tilt_state * flip_multiplier
	else:
		_flip_timer = 0.0
		_tilt_state = 1
		$AnimatedSprite2D.rotation = 0.0
			
	move_and_slide()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attacking = false
		$AnimatedSprite2D.play("default")
