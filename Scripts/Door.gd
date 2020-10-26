extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed
var activateCount = 0
var activateTarget = 0
var activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		

func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
		
func activate():
	activateCount += 1
	
	if activateCount == activateTarget:
		Global.soundManager.play_sound_DoorOpen()
		$AP.play("Open")
		activated = true
	
func deactivate():
	activateCount -= 1
	if activateCount != activateTarget and activated == true:
		Global.soundManager.play_sound_DoorClose()
		$AP.play_backwards("Open")
		activated = false