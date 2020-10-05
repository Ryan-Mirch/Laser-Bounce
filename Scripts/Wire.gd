extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var mesh = get_node("Mesh")

var scaleY
var connectedObject
var color
var connectedPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	connectedPosition = connectedObject.translation
	connectedPosition.y += 1	
	
	set_length()
	set_orientation()

	
func set_length():
	scaleY = global_transform.origin.distance_to(connectedPosition)
	mesh.scale.y = scaleY
	mesh.translation.z = -scaleY*.5

func set_orientation():
	look_at(connectedPosition, Vector3(0,1,0))
	
func set_color(c):
	var material = SpatialMaterial.new()
	material.albedo_color = c
	mesh.set_material_override(material)
	
	

