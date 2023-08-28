extends Node

var paused = false

func _ready():
	if OS.is_debug_build():
		await get_tree().create_timer(0.5).timeout
		get_window().always_on_top = true

