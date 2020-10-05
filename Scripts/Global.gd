extends Node

var pointerTranslation
var debug = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pointerTranslation = Vector3(0,0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("debug"):
		debug = !debug
			
	
	
