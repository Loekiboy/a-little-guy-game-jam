extends RichTextLabel

func _ready():
	self.text = "[wave] You are the little guys, save the big guy! 
	click to span a litlle guy, attack with e move with wasd[/wave]"
	self.visible_ratio = 0.0
	
	var tween = create_tween()
	var duration = self.get_total_character_count() * 0.05
	tween.tween_property(self, "visible_ratio", 1.0, duration)
	
