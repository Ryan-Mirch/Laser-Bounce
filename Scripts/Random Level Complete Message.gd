extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, String) var messages

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	text = messages[rng.randi_range(0, messages.size()-1)]
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
