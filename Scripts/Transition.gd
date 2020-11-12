extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ap := $"AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	ap.play("Fade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
func transition():
	ap.play_backwards("Fade")

func levelCompleted():
	ap.play_backwards("Level Completed")
	
	
