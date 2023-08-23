extends MeshInstance3D

var highlight = false;

var lightengergy = 0.0

func _on_monitor_area_mouse_entered():
	highlight = true
func _on_monitor_area_mouse_exited():
	highlight = false
	
func _process(delta):
	timer += delta * 0.0003171
	if highlight && !get_parent().get_parent().viewingMonitor:
		lightengergy = 1.0
	else:
		lightengergy = 0.0
		
	$Sprite3D.modulate.a = lerp($Sprite3D.modulate.a, lightengergy, 0.3)

var timer = 0.64582751

func _ready():
	output()
	
func output():
	await get_tree().create_timer(0.2).timeout
	$Label.text = " Δ " + str(round_to_dec(timer*0.0001,10)) + " ly "
	for j in 3:
		$Label.text += "\n"
		for i in 10:
			$Label.text += randarr.pick_random()
	output()

var randarr = ["?︎","▘︎",
"▙︎","◐︎","▒︎","▒︎","▒︎","█","▒︎","░︎︎","█︎","░︎","░︎","░︎","█",
"▙︎","█","ញ︎","⁛︎","⚗︎"]

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
