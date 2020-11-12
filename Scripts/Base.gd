extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var meshDrag = get_node("Mesh Drag")
onready var mesh90 = get_node("Mesh 90")
onready var mesh45 = get_node("Mesh 45")

export var draggable = false
export(String, "none", "45", "90") var rotationType = "none"

var attachedObject

var DragOffset = 0.2
var dragging = false
var drop_point

var newRotationYAttached
var newRotationYRotatable
var step = 0

signal pressed




# Called when the node enters the scene tree for the first time.
func _ready():
	getAttachedObject()
	attachedObject.connect("pressed", self, "_on_Attached_Pressed")
	
	newRotationYAttached = attachedObject.rotation_degrees.y
	newRotationYRotatable = mesh90.rotation_degrees.y
	drop_point = translation
	
	if rotationType == "45": step = 45
	if rotationType == "90": step = 90
	setMeshVisibility()
	setRotationMeshHeight()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mesh90.rotation_degrees.y = lerp(mesh90.rotation_degrees.y, newRotationYRotatable, 20 * _delta)	
	mesh45.rotation_degrees.y = lerp(mesh45.rotation_degrees.y, newRotationYRotatable, 20 * _delta)	
	attachedObject.rotation_degrees.y = lerp(attachedObject.rotation_degrees.y, newRotationYAttached, 20 * _delta)	
	
	if dragging:
		translation = Global.pointerTranslation
		translation.y = translation.y + DragOffset
	else:
		translation.x = lerp(translation.x, drop_point.x , 0.2)
		translation.y = lerp(translation.y, drop_point.y, 0.2)
		translation.z = lerp(translation.z, drop_point.z, 0.2)

func getAttachedObject():
	for n in get_children():
		if n is Spatial:
			attachedObject = n

func setRotationMeshHeight():
	if !draggable and rotationType != "none":
		mesh90.translation.y += -.25
		mesh45.translation.y += -.25

func setMeshVisibility():
	meshDrag.visible = draggable
	
	if rotationType == "none":
		mesh90.visible = false
		mesh45.visible = false
	if rotationType == "45":
		mesh90.visible = false
		mesh45.visible = true
	if rotationType == "90":
		mesh90.visible = true
		mesh45.visible = false

func _dragStart():
	dragging = true
	add_to_group("Dragging")
	Sounds.play_sound_PickUp()
	var tile = _get_closest_tile("Closed")
	if tile != null: tile.setOpen(true)
	
	
func _input(event):		
	
	if event.is_action_released("grab") and dragging:		
		dragging = false
		
		var tile = _get_closest_tile("Open")
		if tile != null: tile.setOpen(false)
		drop_point = tile.translation
		
		remove_from_group("Dragging")
		Sounds.play_sound_PutDown()
		
func _get_closest_tile(state): 
	var tiles =  get_tree().get_nodes_in_group("Tile")
	var shortest = -1
	var tile
	
	for t in tiles:
		
		if state == "Open":
			if t.isOpen() == false: #skip if closed
				continue
		if state == "Closed":
			if t.isOpen() == true: #skip if open
				continue
			
		var currentDistance = t.translation.distance_to(global_transform.origin)
		if currentDistance < shortest or shortest == -1:
			shortest = currentDistance
			tile = t
			
	return tile

	
func get_dragging():
	return dragging


func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
		


func _on_Click_Manager_dragStart():
	if draggable: _dragStart()
	
func _on_Click_Manager_clicked():
	if rotationType != "none": 
		newRotationYAttached = newRotationYAttached + step
		newRotationYRotatable = newRotationYRotatable + step
		Sounds.play_sound_Rotate()
	



func _on_Attached_Pressed():
	emit_signal("pressed")
