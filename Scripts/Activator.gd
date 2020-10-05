extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed

var activatedCount = 0

export var color = Color(1,1,1)
export(Array, NodePath) var activatedObjects

onready var wire = load("res://Assets/Wire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("spawn_wires")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):	
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
			
func activated():
	if activatedObjects.size() > 0:
		for path in activatedObjects:
			get_node(path).activate()
	
	
func deactivated():
	if activatedObjects.size() > 0:
		for path in activatedObjects:
			get_node(path).deactivate()

func _on_Area_body_entered(body):
	var sensedColor = body.get_parent().color
	if check_color(sensedColor): 
		activatedCount += 1
		
		if activatedCount == 1:
			activated()
		
	

func _on_Area_body_exited(body):
	var sensedColor = body.get_parent().color
	if check_color(sensedColor): 
		activatedCount -= 1
		activatedCount = clamp(activatedCount, 0, 100)
		
		if activatedCount == 0:
			deactivated()


func check_color(_c): #check if the color is correct
	return true
	
func spawn_wires():	
	if activatedObjects.size() > 0:
		for path in activatedObjects:
			
			var n = get_node(path)
			
			n.activateTarget += 1
			
			var newWire = wire.instance()
			newWire.connectedObject = n
			newWire.translation.y = translation.y + 1.5
			newWire.color = color
			add_child(newWire)

func _on_Sphere_ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$"Sphere".set_material_override(material)


func _on_Cube052_ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$"Cube052".set_material_override(material)


func _on_Cube075_ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$"Cube074/Cube075".set_material_override(material)
