extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed

var activateCount = 0
var activateTarget = 0
var activated = false

var beamSpawn

onready var beam = load("res://Assets/Beam.tscn")
export var color = Color(1,1,1)

export (NodePath) var coloredObjectPath
onready var coloredObject = get_node(coloredObjectPath)
onready var tip = get_node("Cylinder/Tip")

# Called when the node enters the scene tree for the first time.
func _ready():
	SetDarkness(0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated:
		tip.rotate_y(delta * deg2rad(360))
		
func Play():
	if !activated and activateCount >= activateTarget:		
		activated = true
		beamSpawn = beam.instance()
		beamSpawn.translation = Vector3(0,2.7,1.001)
	
		add_child(beamSpawn)
		SetDarkness(0)
	
func Stop():
	if activated:
		var beamChild = get_node_or_null("Beam")
		if beamChild != null: beamChild.queue_free()
		
		activated = false
		SetDarkness(0.5)

func SetDarkness(darkness):
	var material = SpatialMaterial.new()
	material.albedo_color = color.darkened(darkness)
	material.flags_unshaded = false
	coloredObject.set_material_override(material)

func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
		


func _on_Tip_ready():
	tip = get_node("Cylinder/Tip")
	var material = SpatialMaterial.new()
	material.albedo_color = color
	tip.set_material_override(material)
	
func activate():
	activateCount += 1
	print("activated")
	
	
func deactivate():
	activateCount -= 1
	activateCount = clamp(activateCount, 0, 100)
	if activateCount != activateTarget and activated == true:
		Stop()
		
