extends Sprite3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a -= delta * 1.1
	if modulate.a <= 0.0:
		queue_free()
