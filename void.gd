extends MeshInstance3D

var ping = 1.0

func _process(delta):
	ping -= delta * 0.004
	var tex = material_override as StandardMaterial3D
	tex.uv1_offset.y = ping
	
