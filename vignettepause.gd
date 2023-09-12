extends Node3D

func _process(delta):
	if visible:
		rotate_z(delta * 0.02)
		rotate_x(delta * 0.03)
