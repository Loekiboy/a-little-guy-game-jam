extends Node2D

func _ready() -> void:
	$RichTextLabel.text = "Hey litlle guy you lost
[wave amp=50.0 connected=0][rainbow  freq=0.2speed=0.5]Big guy ded LOL![img=64x64]res://assets/big-guy.png[/img][/rainbow][/wave]
your score is: " + str(int(TimeGlobal.time_seconds)) + "
try again to save big guy?" 
