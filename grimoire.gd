extends Node

var paused = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	get_window().always_on_top = true

