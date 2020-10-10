extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed

onready var beam = load("res://Assets/Beam.tscn")
export var color = Color(1,1,1)
export var absorberColor = Color(1,1,1)

var activatedCount = 0
var beamSpawn
var activated = false
var hasShot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activated():
	activated = true
	
	
func deactivated():
	if beamSpawn != null: beamSpawn.queue_free()
	activated = false
	hasShot = false
	
func check_color(c): #check if the color is correct
	if absorberColor == c: return true
	if absorberColor == Color(1,1,1): return true
	if c == Color(1,1,1): return true
	return false

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

func play():
	beamSpawn = beam.instance()
	beamSpawn.translation = Vector3(0,2.416,1.001)
	
	add_child(beamSpawn)
	
	hasShot = true
	


func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
		
func shoot():
	print("shoot")
	if !activated: return
	if hasShot: return
	play()
	

func _on_Tip_ready():
	var tip = get_node("Cylinder/Tip")
	var material = SpatialMaterial.new()
	material.albedo_color = color
	tip.set_material_override(material)
	
func _on_Sphere_ready():
	var material = SpatialMaterial.new()
	material.albedo_color = absorberColor
	$"Cylinder/Sphere".set_material_override(material)