extends MeshInstance3D

var shutofftimer = 0

func _process(delta):
	rotate_y(0.1*delta)
	shutofftimer += delta
	if shutofftimer >= 5:
		get_tree().quit()
