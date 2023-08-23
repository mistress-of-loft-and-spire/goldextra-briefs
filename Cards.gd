extends Node3D

@onready var cardTemplate = preload("res://CardTemplate.tscn")
@onready var cardStack = preload("res://CardStack.tscn")
@onready var mesTemplate = preload("res://Message.tscn")
var flavorString = ""

var cursorPos = Vector2(0,0)

var pause = false

var hoveredCard = null

func _process(delta):
	print(hoveredCard)

func _ready():
	
	var file = FileAccess.open("res://assets/img/flavor.txt", FileAccess.READ)
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		flavorString += file.get_line() + "\n"
	file.close()
	
	addStack()
	
	addCard(Vector2(3,0),"pig","char","Crew")
	addCard(Vector2(6,0),"pig","char2","Crew")
	addCard(Vector2(0,0),"ship","ship","Ship")

	var planet = addCard(Vector2(5,5),"planet","planet","Waning View")
	planet.countdown = 60.0
	
	var sig = addCard(Vector2(10,10),"signal","signal","The Signal")
	sig.countdown = 60.0
	
	addMessage("The year is 2091...
	In their insatiable hunger for celestial expansion humanity has ravaged the solar system, leaving barren and inhospitable planets.
	A small human population survives in orbit: Keeping their bodies alive with tissue derived from cybernetically altered laboratory animals such as pigs.
	This is a test. This is a test. This is a test. This is a test. This is a test. This is a test. This is a test.")

func drawCard(pos:Vector3):
	var card
	
	match randi_range(0,10):
		#										type	 name(img)	displayname
		1:
			card = addCard(Vector2(pos.x,pos.z), "irons", "swords", "Irons")
		2:
			card = addCard(Vector2(pos.x,pos.z), "fuel", "wands", "Fuel")
		3:
			card = addCard(Vector2(pos.x,pos.z), "cohesion", "coins", "Cohesion")
		4:
			card = addCard(Vector2(pos.x,pos.z), "organs", "cups", "Organs")
		_:
			card = addCard(Vector2(pos.x,pos.z), "char", "char", "Test")
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
	
	card.root = self
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

func addStack() -> Node3D:
	var card = cardStack.instantiate()
	
	card.type = "stack"
	card.label = getFlavor("stack")
	
	card.name = "stack"
	
	card.position.x = -5; card.position.z = 0
	
	card.root = self
	add_child(card)
	return(card)
