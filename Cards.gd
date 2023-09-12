extends Node3D

@onready var cardTemplate = preload("res://CardTemplate.tscn")
@onready var cardStack = preload("res://CardStack.tscn")
@onready var mesTemplate = preload("res://Message.tscn")
@onready var endgames = preload("res://planet.tscn")

var cursorPos = Vector2(0,0)

var pause = false

var hoveredCard = null

var signalsolved = false
var deadcrew = 0

func dopause():
	pause = true
	get_parent().get_node("paused").visible = true
	get_parent().get_node("music").pitchtarget = 0.3
func unpause():
	pause = false
	get_parent().get_node("paused").visible = false
	get_parent().get_node("music").pitchtarget = 1.0

func quitgame():
	get_parent().get_node("ViewFrame").visible =false
	get_parent().get_node("TablePan").visible =false
	get_parent().get_node("Table").visible =false
	get_parent().add_child(endgames.instantiate())
	
func lost(how:String = "signal"):
	match how:
		"goaltimeout":
			dopause()
			addMessage("We try searching for any kind of defense against THE SIGNAL but time and again come up empty-handed. As we continue to push further into the VOID in an attempt to evade THE SIGNAL, the HOSPITABLE PLANET soon vanishes from view and then even from our sensors.\n\nThis chance having passed us, we carry on for a while. But out here in the darkness resources are sparse and soon we find ourselves running out of fuel and materials and spirit. The vast emptiness has now become our tomb.\n\nPress OK to restart. Once finding the HOSPITABLE PLANET you only have a short time to reach it with MOMENTUM. Try experimenting with card combinations to find a way to disarm THE SIGNAL before you are out of reach.","restart")
		"signal":
			dopause()
			addMessage("We try to push on but THE SIGNAL has now permeated the ship and the crew within. There is nothing to be done as its presence is silently injecting itself into the fabric of our DNA. Everything turns dark as the SHIP continues to drift aimlessly in the interstellar VOID.\n\nPress OK to restart. Be mindful of the SIGNAL countdown. Add MOMENTUM to increase the count. Try experimenting with card combinations to find a way to disarm THE SIGNAL before it reaches you.","restart")
		"goal":
			dopause()
			if signalsolved:
				addMessage("Finally, after one last cautious examinination of the readings, we make landfall on the surface of the HOSPITABEL PLANET.\n\nWith the SIGNAL's algorithm disarmed and being far out of reach of the humans we can finally take rest and recover. We are sure though that this will not be the final chapter of our journey... \n\nPress OK to quit game.","quit")
			else:
				addMessage("Desperately we make landfall on the surface. An arduous journey behind us...\n\nTaking rest on the surface, however, is a short-lived relieve. With THE SIGNAL still propagating through the interstellar VOID it soon catches up with us. There is nothing to be done as its presence is silently injecting itself into the fabric of our DNA. This celestial refuge has now become our tomb as everything turns dark.\n\nPress OK to restart. Try experimenting with card combinations to find a way to disarm THE SIGNAL before reaching the HOSPITABLE PLANET.","restart")
		"dead":
			dopause()
			addMessage("Our ship drifts quietly through the darkness. The engines are headlessly pushing on in between the stars. It is a long time before even they fall silent. But by then none of us remain to witness it.\n\nAll of our CREW have perished before reaching the HOSPITABLE PLANET. Try keeping them alive with the use of MEDICINE. But if you do lose one of your CREW perhaps there is some way to bring them back?\n\nPress OK to restart.","restart")
		"shipdead":
			dopause()
			addMessage("As the engines sputter to a halt, one after another all the SHIP's systems slowly die down. The hull groans, temparature falls and for a while those of us who still remain in this darkness gasp for air as the oxygen tanks deplete.\n\nOur SHIP was destroyed before reaching the HOSPITABLE PLANET. Try keeping it in good enough shape with the use of IRONS.\n\nPress OK to restart.","restart")

var deck = []

func _ready():
	#22 cards:
		# planet - 4.4
		# planetoid - 4.4
		# asteroid - 4.4
		# wreckage - 2.2
		# flotsam - 4.4
		# vacuum - 2.2
	var a = []
	a.append("planet"); a.append("planetoid"); a.append("asteroid");a.append("vacuum");
	a.append("wreckage"); a.append("flotsam"); a.append("planet");a.append("vacuum");
	a.shuffle()
	
	deck.append_array(a) #8
	
	a = []
	a.append("planet"); a.append("planetoid"); a.append("asteroid");
	a.append("wreckage"); a.append("vacuum"); a.append("vacuum");
	a.shuffle()
	
	deck.append_array(a) #14
	
	a = []
	a.append("planet"); a.append("planetoid"); a.append("asteroid");a.append("wreckage");
	a.append("wreckage"); a.append("flotsam"); a.append("vacuum");a.append("planet"); 
	a.shuffle()
	
	deck.append_array(a) #22
	
	dopause()
	
	addStack(Vector2(-10,0))
	
	addCard(Vector2(4,0),"pig")
	addCard(Vector2(7,0),"pig")
	addCard(Vector2(0,0),"ship")
	
	
	var fuela = addCard(Vector2(3,6),"fuel")
	var fuelb = addCard(Vector2(3,6), "fuel")
	fuela.placeCardOnTop(fuelb,fuela)

	addMessage("The year is 2091. Humanity has desolated the solar system in their unrelenting quest for resources and expansion. Amidst this celestial wreckage cybernetically altered swine are grown in orbital organ farms, to bridge the gap in a world plagued by ORGAN shortages.\n\nWe, a small CREW of porcines, have escaped this eternal machine. Our escape a matter of urgency, we have readied ourselves to defy the cosmos itself and find a new home among the celestial tapestry.\n\nIt is unclear how long it will be until we can find a HABITABLE PLANET outside of the reach of humanity...\n\nOnce we are ready, we can push on by drawing a card from the VOID stack.\n\nUse left mouse to drag cards and pan view.\nUse mouse wheel to scroll text and zoom view.\nUse space to pause.", "unpause")



func drawCard(pos:Vector3, type:String):
	var card
	if type != null && type != "":
		match type:
			"signal":
				card = addCard(Vector2(pos.x,pos.z),"signal")
				card.issignal = true
			"origin":
				card = addCard(Vector2(pos.x,pos.z),"origin")
			"goal":
				card = addCard(Vector2(pos.x,pos.z),"goal")
				card.isgoal = true
			"altered":
				card = addCard(Vector2(pos.x,pos.z),"altered")
	else:
		
		card = addCard(Vector2(pos.x,pos.z), deck.pop_back())
		
	card.pickUp()
#			1,2:
#				card = addCard(Vector2(pos.x,pos.z), "planet")
#				card.countdown = 60.0
#			3,4:
#				card = addCard(Vector2(pos.x,pos.z), "planetoid")
#				card.countdown = 45.0
#			5:
#				card = addCard(Vector2(pos.x,pos.z), "asteroid")
#				card.countdown = 30.0
#			7:
#				card = addCard(Vector2(pos.x,pos.z), "wreckage")
#				card.countdown = 30.0
#			8,9:
#				card = addCard(Vector2(pos.x,pos.z), "flotsam")
#				card.countdown = 30.0
#			_:
#				card = addCard(Vector2(pos.x,pos.z), "vacuum")
#				card.countdown = 10.0
	
	

func addCard(pos:Vector2 = Vector2(0.0,0.0), id:String = "cardid") -> Node3D:
	var card = cardTemplate.instantiate()
	
	print(id)
	
	#get data from flavor
	var findtext = ""
	var cardData = ""
	var finderPos = Grimoire.flavor.find("#"+id)
	if finderPos != -1:
		var endPos = Grimoire.flavor.find("#",finderPos+1)
		cardData = Grimoire.flavor.substr(finderPos+id.length()+1,endPos-(finderPos+id.length()+1))
	#print(id + "  " + str(Grimoire.flavor.find("#",finderPos+1)))
	
	#get types
	card.types.append(id)
	
	findtext = "additionaltype=["
	finderPos = cardData.find(findtext)
	if finderPos != -1:
		var endPos = cardData.find("]",finderPos)
		var splits = cardData.substr(finderPos+findtext.length(),endPos-(finderPos+findtext.length())).split(",")
		for s in splits:
			card.types.append(s)
		cardData = cardData.substr(endPos+1)
	
		
		
	#img
	findtext = "img=["
	finderPos = cardData.find(findtext)
	if finderPos != -1:
		var endPos = cardData.find("]",finderPos)
		var imgurl = cardData.substr(finderPos+findtext.length(),endPos-(finderPos+findtext.length()))
		var texture = load("res://assets/img/" + imgurl + ".png")
		card.get_node("Visual/Illu").texture = texture
		cardData = cardData.substr(endPos+1)
	else:
		var texture = load("res://assets/img/" + id + ".png")
		card.get_node("Visual/Illu").texture = texture
		
	#name
	var displayname = id
	
	findtext = "name=["
	finderPos = cardData.find(findtext)
	if finderPos != -1:
		var endPos = cardData.find("]",finderPos)
		displayname = cardData.substr(finderPos+findtext.length(),endPos-(finderPos+findtext.length()))
		cardData = cardData.substr(endPos+1)

	card.get_node("Visual/Name").text = displayname

	if displayname.length() >= 10:
		card.get_node("Visual/Name").font_size = (10.0/float(displayname.length())) * 80

		
	#countdown
	findtext = "countdown=["
	finderPos = cardData.find(findtext)
	if finderPos != -1:
		var endPos = cardData.find("]",finderPos)
		var cstring = cardData.substr(finderPos+findtext.length(),endPos-(finderPos+findtext.length()))
		var elems = cstring.split("->")
		card.countdown = float(elems[0])
		if elems.size() > 1:
			card.turninto = elems[1]
		cardData = cardData.substr(endPos+1)
		
	#recipe
	findtext = "recipe=["
	finderPos = cardData.find(findtext)
	if finderPos != -1:
		var endPos = cardData.find("]",finderPos)
		var splits = cardData.substr(finderPos+findtext.length(),endPos-(finderPos+findtext.length())).split(",")
		for s in splits:
			var parts = s.split("->")
			var sec = float(parts[1].rstrip("s"))
			var amount = parts[3].split_floats("||")
			var cardsgenedstr = parts[4].substr(1,parts[4].length()-2)
			card.recipe.append([parts[0],sec,parts[2],amount,cardsgenedstr.split(";")])
		print(card.recipe)
		cardData = cardData.substr(endPos+1)
		
		
	
	#flavor text
	card.label = displayname.to_upper() + "\n" + cardData
	
	if id == "log":
		print("LOGLOGLOGLOG")
		var pickone = [
			"💧->🚀       💗->🚀\n\n🦴->🚀      🔧->🚀🔥=🚀",
			"🔧->💗=🕸💗",
			"🦠=???",
			"🕸->🚀=🦠",
			"💧->🦠=💧💧💧💧💧",
			"‍💥🕸💗->🦠\n\n🕸🐷->🦠=📡❌",
			"🕸💗->🐷=🕸🐷",
			"📡=💀"
		]
		var lognum = randi_range(0,pickone.size()-1)
		if logsadded.size() != pickone.size():
			while logsadded.has(lognum):
				lognum = randi_range(0,pickone.size()-1)
				if lognum >= pickone.size():
					lognum = 0
			logsadded.append(lognum)
		
		card.get_node("Visual/Name").text += " #" + str(lognum+1)
		
		card.get_node("Label/bigtext").text = pickone[lognum]
		if card.get_node("Visual/Name").text.length() >= 10:
			card.get_node("Visual/Name").font_size = (10.0/float(card.get_node("Visual/Name").text.length())) * 80


	card.position.x = pos.x; card.position.z = pos.y

	card.root = self
	add_child(card)
	return(card)
	
var logsadded = []

func addMessage(text:String, onOk:String = ""):
	var message = mesTemplate.instantiate()
	message.position.x = get_parent().camPan.x
	message.position.z = -get_parent().camPan.y
	message.label = text
	message.onOk = onOk
	add_child(message)

func addStack(pos:Vector2) -> Node3D:
	var card = cardStack.instantiate()
	
	card.type = "stack"
	card.label = "THE VOID\n\nWe draw cards from this stack to chart a course through chaos."
	
	card.name = "stack"
	
	card.position.x = pos.x; card.position.z = pos.y
	
	card.root = self
	add_child(card)
	return(card)
