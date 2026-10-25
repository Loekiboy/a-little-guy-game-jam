extends Node2D

func _ready():
	set_visible(true)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		set_visible(false)
