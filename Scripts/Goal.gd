extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal LevelComplete
export var setColor = Color(1,1,1,1)
var activatedCount = 0
var newMaterial
onready var glow = get_node("Glow")
var cyclesAfterHit = 0
var activated = false
var levelComplete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	check()

func check():
	if activated and cyclesAfterHit > 0 and !levelComplete:
		emit_signal("LevelComplete")
		print("Level Complete")
		newMaterial.flags_unshaded = true
		glow.visible = true
		levelComplete = true
		
func cycleCount():
	if activated:
		cyclesAfterHit += 1

func activate():
	activated = true
	

func deactivated():
	activated = false
	cyclesAfterHit = 0


func _on_Area_body_entered(body):
	var sensedColor = body.get_parent().color
	if check_color(sensedColor): 
		activatedCount += 1
		
		if activatedCount == 1:
			activate()


func _on_Area_body_exited(body):
	var sensedColor = body.get_parent().color
	if check_color(sensedColor): 
		activatedCount -= 1
		activatedCount = clamp(activatedCount, 0, 100)
		
		if activatedCount == 0:
			deactivated()

func check_color(c): #check if the color is correct
	if setColor == c: return true
	if setColor == Color(1,1,1): return true
	if c == Color(1,1,1): return true
	return false

func _on_Sphere001_ready():
	newMaterial = SpatialMaterial.new()
	newMaterial.albedo_color = setColor
	
	
	$"Cube033/Sphere001".set_material_override(newMaterial)
