extends Node2D

@export var player_scene: PackedScene
@export var heart_scene: PackedScene
@export var fall_distance: float = 40.0

var spawn_area: Rect2 = Rect2(0, 0, 1152, 648)
@export var amount_at_start: int = 20
@export var spawn_interval: float = 5.0

var player_to_span := 100

@onready var heart_timer: Timer = $HeartTimer

func _ready() -> void:
	_update_counter()
	
	for i in amount_at_start:
		spawn_heart()
	
	heart_timer.wait_time = spawn_interval
	heart_timer.timeout.connect(spawn_heart)
	heart_timer.start()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and player_to_span > 0:
		spawn_player()
		player_to_span -= 1
		_update_counter()

func add_player_to_span(amount: int = 1) -> void:
	player_to_span += amount
	_update_counter()

func _update_counter() -> void:
	$CharacterBody2D/Camera2D/counter.text = str(player_to_span) + "[img]res://assets/litlle guy/little-guy-icon.png[/img]"

func spawn_heart() -> void:
	var cam = get_viewport().get_camera_2d()
	if cam:
		var camx = cam.global_position.x
		var camy = cam.global_position.y
		var heart = heart_scene.instantiate()
		heart.position = Vector2(
			randf_range(camx - 800, camx + 800),
			randf_range(camy - 400, camy + 400)
		)
		add_child(heart)

func spawn_player() -> void:
	var player = player_scene.instantiate()
	add_child(player)

	player.global_position = get_global_mouse_position()
	player.scale = Vector2(1.5, 1.5)

	player.set_process(false)
	player.set_physics_process(false)
	player.set_process_unhandled_input(false)

	var target_y: float = player.position.y + fall_distance
	var anim_sprite = player.find_child("AnimatedSprite2D", true, false)

	anim_sprite.play("fall")

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(player, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "position:y", target_y, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	await tween.finished

	player.set_process(true)
	player.set_physics_process(true)
	anim_sprite.play("default")
