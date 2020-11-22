extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed

var activatedCount = 0
var wires = []

export var color = Color(255,255,255)
export(Array, NodePath) var activatedObjects
export (NodePath) var coloredObjectPath
onready var coloredObject = get_node(coloredObjectPath)

onready var wire = load("res://Assets/Wire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("spawn_wires")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.playing && activatedCount != 0:
		deactivated()
		

func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):	
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
			
func activated():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	#material.flags_unshaded = true
	coloredObject.set_material_override(material)
	
	for w in wires:
		w.activate()
	
	if activatedObjects.size() > 0:
		for path in activatedObjects:
			get_node(path).activate()
	
	
func deactivated():
	var material = SpatialMaterial.new()
	material.albedo_color = color.darkened(0.5)
	#material.flags_unshaded = false
	coloredObject.set_material_override(material)
	
	activatedCount = 0
	if activatedObjects.size() > 0:
		for w in wires:
			w.deactivate()
		
		for path in activatedObjects:
			get_node(path).deactivate()

func _on_Area_body_entered(body):
	var sensedColor = body.get_parent().color
	if check_color(sensedColor): 
		activatedCount += 1
		
		if activatedCount == 1:
			activated()
	else:
		activatedCount -= 1
		
		if activatedCount < 1:
			deactivated()
		
	

func _on_Area_body_exited(body):
	var sensedColor = body.get_parent().color
	if check_color(sensedColor): 
		activatedCount -= 1
		activatedCount = clamp(activatedCount, 0, 100)
		
		if activatedCount < 1:
			deactivated()
	else: 
		activatedCount += 1
		
		if activatedCount == 1:
			activated()


func check_color(c): #check if the color is correct
	if color == c: return true
	if color == Color(1,1,1): return true
	if c == Color(1,1,1): return true
	return false
	
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
			wires.append(newWire)

func _on_Sphere_ready():
	coloredObject = get_node(coloredObjectPath)
	var material = SpatialMaterial.new()
	material.albedo_color = color.darkened(0.5)
	material.emission_enabled = false
	coloredObject.set_material_override(material)


func _on_Cube052_ready():
	coloredObject = get_node(coloredObjectPath)
	var material = SpatialMaterial.new()
	material.albedo_color = color.darkened(0.5)
	coloredObject.set_material_override(material)


func _on_Cube075_ready():
	coloredObject = get_node(coloredObjectPath)
	var material = SpatialMaterial.new()
	material.albedo_color = color.darkened(0.5)
	coloredObject.set_material_override(material)

	
