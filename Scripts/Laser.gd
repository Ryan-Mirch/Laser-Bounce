extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed

onready var beam = load("res://Assets/Beam.tscn")
export var color = Color(1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Play():
	var beamSpawn = beam.instance()
	beamSpawn.translation = Vector3(0,2.7,1.001)
	
	add_child(beamSpawn)


func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
		


func _on_Tip_ready():
	var tip = get_node("Cylinder/Tip")
	var material = SpatialMaterial.new()
	material.albedo_color = color
	tip.set_material_override(material)
