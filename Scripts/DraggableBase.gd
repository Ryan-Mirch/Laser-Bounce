extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var DragOffset = 0.5

var dragging = false
var drop_point

signal pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	drop_point = translation
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if dragging:
		translation = Global.pointerTranslation
		translation.y = translation.y + DragOffset
	else:
		translation.x = lerp(translation.x, drop_point.x , 0.2)
		translation.y = lerp(translation.y, drop_point.y, 0.2)
		translation.z = lerp(translation.z, drop_point.z, 0.2)

func _dragStart():
	dragging = true
	add_to_group("Dragging")
	
	var tile = _get_closest_tile("Closed")
	if tile != null: tile.setOpen(true)
	
	
func _input(event):		
	if event.is_action_released("grab") and dragging:
		dragging = false
		
		var tile = _get_closest_tile("Open")
		if tile != null: tile.setOpen(false)
		drop_point = tile.translation
		
		remove_from_group("Dragging")
		
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
			
		var currentDistance = t.translation.distance_to(translation)
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
	_dragStart()
