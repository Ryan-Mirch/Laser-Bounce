extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var pitch = 1
export(float) var pitchLower = 1
export(float) var pitchUpper = 1
export(float) var volume = 0

export(String, DIR) var soundDirectory
var sounds = []
var soundsPath

# Called when the node enters the scene tree for the first time.
func _ready():
	loadSounds(soundDirectory)
		

func loadSounds(path):
	soundsPath = path
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	sounds.clear()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with(".") and file.ends_with(".import"):
			sounds.append(load((path + "/" + file).replace(".import","")))
			
func getSoundsPath():
	return soundsPath

func playSound(randomPitch):	
	if !sounds.size() > 0: return
	var soundSample = AudioStreamSample.new()
	var asp = AudioStreamPlayer.new()
	get_parent().add_child(asp)
	asp.connect("finished", self, "removeASP",[asp])
	
	if(randomPitch):asp.pitch_scale = rand_range(pitchLower, pitchUpper)
	else:asp.pitch_scale = pitch
	
	asp.volume_db = volume
	
	soundSample = sounds[randi() % sounds.size()]	
	
	asp.stream = soundSample
	asp.play()
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func removeASP(asp):
	asp.queue_free()
