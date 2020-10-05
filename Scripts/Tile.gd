extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var open = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setOpen(b):
	open = b
	
func isOpen():
	return open
