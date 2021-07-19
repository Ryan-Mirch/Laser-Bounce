extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0 # 0 = edit 1 = play
var complete = false
export(String, FILE, "*.tscn,*.scn") var nextLevelPath

onready var levelUI = get_node("LevelUI")
onready var timer = get_node("Cycle Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentScene = self
	var _x = Saving.connect("saveDataUpdated",self,"set_cycle_duration")
	set_cycle_duration()
	Edit()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Global.complete = complete
	
func _physics_process(_delta):
	pass
	
func Play():
	Sounds.play_sound_PlayLevel()	
	Global.playing = true
	get_tree().call_group("Base","endDragging")
	timer.start()
	
func Edit():
	Sounds.play_sound_StopLevel()
	get_tree().call_group("Laser","Stop")
	get_tree().call_group("Laser Absorber", "deactivated")
	Global.playing = false
	timer.stop()
	complete = false
	

func _on_Cycle_Timer_timeout():
	timer.start()
	get_tree().call_group("Laser","Play")
	get_tree().call_group("Beam", "bounce")
	get_tree().call_group("Laser Absorber", "shoot")
	get_tree().call_group("Goal", "cycleCount")

func _on_Goal_LevelComplete():
	Sounds.play_sound_Win()
	complete = true
	levelUI._Level_Complete()
	Saving.updateLevelCompleted(getLevelID(), true)
	

func play_pressed():
	if state == 0:
		state = 1
		Play()		
		print("play")
	elif state == 1:
		state = 0
		Edit()
		print("edit")

func set_cycle_duration():
	var timer = get_node("Cycle Timer")
	timer.wait_time = Saving.bounce_speed
	
func getLevelID():
	var result = get_filename()
	print(result)
	
	return result

