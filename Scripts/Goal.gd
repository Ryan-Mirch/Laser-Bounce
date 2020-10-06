extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal LevelComplete
export var color = Color(255,255,255)
var activatedCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activated():
	emit_signal("LevelComplete")
	print("Level Complete")

func deactivated():
	pass


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

func check_color(c): #check if the color is correct
	if color == c: return true
	if color == Color(255,255,255): return true
	if c == Color(255,255,255): return true
	return false

func _on_Sphere001_ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$"Cube033/Sphere001".set_material_override(material)
