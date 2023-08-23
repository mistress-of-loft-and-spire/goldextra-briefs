extends Node3D

@onready var cursor:Node3D = $Cursor
@onready var cursorAnim:AnimationPlayer = get_node("Cursor/AnimationPlayer")

var cassetteTemplate = preload("res://scenes/meta/Cassette.tscn")

var screenRatio:float
var uiScaleFactor = 34.78

var mouseDown = false
var dragElement : UIElement = null

var uiElements : Array[UIElement] = []

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().root.connect("size_changed",Callable(self,"viewportSizeChanged"))
	viewportSizeChanged()
	
	uiElements.append_array(findElements($Left))
	uiElements.append_array(findElements($Right))
	
	addCassette()
	

func _process(delta):

	var mouseRatio = Vector2.ZERO
	mouseRatio.x =  get_viewport().get_mouse_position().x / get_viewport().size.x
	mouseRatio.y =  get_viewport().get_mouse_position().y / get_viewport().size.y
	cursor.position.x = (mouseRatio.x * screenRatio - screenRatio / 2) * uiScaleFactor
	cursor.position.y = (mouseRatio.y * -uiScaleFactor) + uiScaleFactor / 2
	
	var collider = $Cursor/RayCast3D.get_collider()
	
	var colliderDraggable = false
	if collider:
		colliderDraggable = collider.draggable
		
	
	if dragElement != null:
		dragElement.dragTo(Vector2(cursor.position.x, cursor.position.y))

	if Input.is_action_just_released("click"):
		if dragElement != null:
			dragElement = dragElement.endDrag()
			#check for drag interaction here
	
	elif Input.is_action_just_pressed("click"):
		if colliderDraggable:
			dragElement = collider.startDrag(Vector2(cursor.position.x, cursor.position.y))
			cursorAnim.play("Drag", 0.06)
		else:
			if collider != null:
				collider.click()
			cursorAnim.play("ClickDown")
			
	elif !Input.is_action_pressed("click"):
		if colliderDraggable:
			cursorAnim.play("CanDrag", 0.1)
		else:
			cursorAnim.play("Point", 0.1)

func viewportSizeChanged():
	screenRatio = 1.0 * get_viewport().size.x / get_viewport().size.y

	$Left.position.x = (-screenRatio / 2) * uiScaleFactor
	$Right.position.x = (screenRatio / 2) * uiScaleFactor

	var uiScale = (1.0 / get_viewport().size.y) * 100
	uiScale = 0.1
	
	$Left.scale = Vector3(uiScale * 6, uiScale * 6, uiScale * 6)
	$Right.scale = Vector3(uiScale * 6, uiScale * 6, uiScale * 6)
	cursor.scale = Vector3(uiScale, uiScale, uiScale)
	
func findElements(node:Node):
	var elements : Array[UIElement] = []
	
	for child in node.get_children():
		if child is UIElement:
			elements.append(child)
	
	return elements

func addCassette():
	var cassette = cassetteTemplate.instantiate()
	cassette.position.x = 30
	cassette.position.y = 20
	
	cassette.tapePlayerTarget.x = $Left/CassetteMarker.position.x
	cassette.tapePlayerTarget.y = $Left/CassetteMarker.position.y
	
	$Left.add_child(cassette)
	
	uiElements.append(cassette)
