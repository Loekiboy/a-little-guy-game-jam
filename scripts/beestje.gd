extends CharacterBody2D

var speed: = 130
var flip_interval: float
var tilt_angle: float
var _flip_timer: = 0.0
var _tilt_state: = 1
var random: = 50
var health: = 20
var is_attacking: bool = false 
var is_dead: bool = false 

@onready var health_bar: ProgressBar = $HealthBar
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

var ded_sound: AudioStream = preload("res://assets/sounds/dino ded.wav")


var _damage_timer: Timer

func _ready() -> void:
	add_to_group("dino")
	flip_interval = randf_range(0.15, 0.25)
	tilt_angle = randf_range(0.08, 0.12)
	_flip_timer = randf_range(0.0, flip_interval)
	_tilt_state = 1 if randf() > 0.5 else -1
	update_health_bar()
	$AnimatedSprite2D.play("default")

	_damage_timer = Timer.new()
	_damage_timer.wait_time = 0.5
	_damage_timer.timeout.connect(_on_damage_tick)
	add_child(_damage_timer)
	_damage_timer.start()

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.rotation = 0.0 
		move_and_slide()
		return 

	# go to big guy
	var big_guy = get_tree().get_first_node_in_group("big-guy")
	
	if is_instance_valid(big_guy):
		var my_x = global_position.x
		var my_y = global_position.y
		var target_x = big_guy.global_position.x
		var target_y = big_guy.global_position.y
		
		if my_x + 2 < target_x:
			velocity.x = speed
			$AnimatedSprite2D.flip_h = true 
			$AttackArea.scale.x = -1
			$DamageArea.scale.x = -1
		elif my_x - 2 > target_x:
			velocity.x = -speed
			$AnimatedSprite2D.flip_h = false 
			$AttackArea.scale.x = 1
			$DamageArea.scale.x = 1
		else:
			velocity.x = 0
			
		if my_y + 2 < target_y:
			velocity.y = speed
		elif my_y - 2 > target_y:
			velocity.y = -speed
		else:
			velocity.y = 0
			
	else:
		velocity = Vector2.ZERO
		
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
	#die script
	if health < 1:
		if is_dead:
			return
		is_dead = true
		velocity = Vector2.ZERO
		set_physics_process(false)
		$AnimatedSprite2D.play("death")

		$CollisionShape2D.set_deferred("disabled", true)
		$AttackArea.set_deferred("monitoring", false)
		$DamageArea.set_deferred("monitoring", false)
		
		if is_instance_valid(_damage_timer):
			_damage_timer.stop()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body.is_in_group("player") or body.is_in_group("big-guy"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_dead:
		return
	if body.is_in_group("player") or body.is_in_group("big-guy"):
		is_attacking = false
		$AnimatedSprite2D.play("default")

func _on_damage_tick() -> void:
	if is_dead:
		return
	for body in $DamageArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.die()
		elif body.is_in_group("big-guy"):
			body.damage_beestje()
			

func damage() -> void:
	health -= 1
	update_health_bar()
	
func update_health_bar():
	if is_instance_valid(health_bar):
		health_bar.value = health
