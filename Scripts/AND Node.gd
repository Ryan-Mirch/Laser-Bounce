extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var activateCount = 0
var activateTarget = 0
var activated = false
var activatedCount = 0
var wireOffset = -0.25
var wires = []
var color = Color(1,1,1)

export(Array, NodePath) var activatedObjects
export (NodePath) var coloredObjectPath
onready var coloredObject = get_node(coloredObjectPath)

onready var wire = load("res://Assets/Wire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("spawn_wires")
	setShade(0.6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate():
	
	activateCount += 1
	
	if activateCount == activateTarget && !activated:
		
		activated = true
		
		setShade(0.3)
			
		if activatedObjects.size() > 0:
			for w in wires:
				w.activate()
			
			for path in activatedObjects:
				get_node(path).activate()
				
	
func deactivate():
	
	activateCount -= 1
	activateCount = clamp(activateCount, 0, 100)
	
	if activateCount < activateTarget and activated:
		
		activated = false
		
		setShade(0.6)
		
		if activatedObjects.size() > 0:
			for w in wires:
				w.deactivate()
		
			for path in activatedObjects:
				get_node(path).deactivate()
				
		
func setShade(value):
	var material = SpatialMaterial.new()
	material.albedo_color = color.darkened(value)
	material.flags_unshaded = false
	coloredObject.set_material_override(material)
		
func spawn_wires():	
	if activatedObjects.size() > 0:
		for path in activatedObjects:
			
			var n = get_node(path)
			
			n.activateTarget += 1
			
			var newWire = wire.instance()
			newWire.connectedObject = n
			newWire.translation.y = translation.y - 1.5
			newWire.color = color
			add_child(newWire)
			wires.append(newWire)
