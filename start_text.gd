extends Node2D

func _ready():
	set_visible(true)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		set_visible(false)
