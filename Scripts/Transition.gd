extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ap := $"AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	ap.play_backwards("Fade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
func transition():
	ap.play("Fade")

func levelCompleted():
	ap.play("Level Completed")
	
	
