extends OmniLight3D

@export var speed = 1.0
@export var flicker_strength = 1.0

@onready var basepow = position.x

var timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta * speed
	
	position.x = basepow + (sin(timer)*flicker_strength)
