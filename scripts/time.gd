extends Node2D

var time_seconds: float = 0.0

func _process(delta: float) -> void:
	time_seconds += delta

func reset_timer() -> void:
	time_seconds = 0.0
