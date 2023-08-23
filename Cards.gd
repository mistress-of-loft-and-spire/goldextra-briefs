extends Node3D

@onready var cardTemplate = preload("res://CardTemplate.tscn")
@onready var mesTemplate = preload("res://Message.tscn")
var flavorString = ""

var cursorPos = Vector2(0,0)

var pause = false

var dragging = null

func _ready():
	
	var file = FileAccess.open("res://assets/img/flavor.txt", FileAccess.READ)
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		flavorString += file.get_line() + "\n"
	file.close()
	
	addCard(Vector2(3,0),"pig","char","Waning View")
	addCard(Vector2(6,0),"pig","char2","Surgeon")
	addCard(Vector2(0,0),"ship","ship","Ship")

	var planet = addCard(Vector2(5,5),"event","planet","Waning View")
	planet.countdown = 60.0
	
	var sig = addCard(Vector2(10,10),"event","signal","The Signal")
	sig.countdown = 60.0
	
	addMessage("The year is 2091...
	In their insatiable hunger for celestial expansion humanity has ravaged the solar system, leaving barren and inhospitable planets.
	A small human population survives in orbit: Keeping their bodies alive with tissue derived from cybernetically altered laboratory animals such as pigs.
	This is a test. This is a test. This is a test. This is a test. This is a test. This is a test. This is a test.")

func drawCard(pos:Vector3):
	var card = addCard(Vector2(pos.x,pos.z), "char", "char", "Test")
	card.countdown = 20
	card.pickUp()
	

func addCard(pos:Vector2 = Vector2(0.0,0.0), type:String = "notype", name:String = "noname", displayname:String = "") -> Node3D:
	var card = cardTemplate.instantiate()
	
	card.type = type
	var stri = ""
	if displayname != "":
		stri = displayname
	else:
		stri = name
	
	card.get_node("Visual/Name").text = stri
		
	if stri.length() >= 10:
		card.get_node("Visual/Name").font_size = (10.0/float(stri.length())) * 80
		
	card.label = card.get_node("Visual/Name").text + "\n" + getFlavor(name)
	
	match type:
		_:
			card.name = name
	
	var texture = load("res://assets/img/" + name + ".png")
	card.get_node("Visual/Illu").texture = texture
	
	card.position.x = pos.x; card.position.z = pos.y
	
	add_child(card)
	return(card)

func addMessage(text:String):
	var message = mesTemplate.instantiate()
	message.label = text
	add_child(message)
	
func getFlavor(name:String) -> String:
	var flavor = ""
	var finderPos = flavorString.find(name)
	if finderPos != -1:
		var endPos = flavorString.find(":",finderPos)
		flavor = flavorString.substr(finderPos+name.length(),endPos-(finderPos+name.length()))
	return flavor
