extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var main = get_tree().current_scene
		if main and main.has_method("add_player_to_span"):
			main.add_player_to_span(1)
		queue_free()
