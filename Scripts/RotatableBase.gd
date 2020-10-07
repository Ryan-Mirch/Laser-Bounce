extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var step = 90

var newRotationY = rotation_degrees.y

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation_degrees.y = lerp(rotation_degrees.y, newRotationY, 0.2)	
	


func _on_StaticBody_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("pressed")
		


func _on_Click_Manager_clicked():
	newRotationY = newRotationY + step
