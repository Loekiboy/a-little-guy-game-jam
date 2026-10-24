extends Node2D

@export var player_scene: PackedScene
@export var fall_distance: float = 40.0
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spawn_player()

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
