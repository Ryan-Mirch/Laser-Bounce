extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var pitch = 1
export(float) var volume = 0
export(Array, AudioStreamSample) var sounds
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func playSound():	
	var soundSample = AudioStreamSample.new()
	var asp = AudioStreamPlayer.new()
	get_parent().add_child(asp)
	asp.connect("finished", self, "removeASP",[asp])
	asp.pitch_scale = pitch
	asp.volume_db = volume
	
	soundSample = sounds[randi() % sounds.size()]	
	
	asp.stream = soundSample
	asp.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func removeASP(asp):
	asp.queue_free()
