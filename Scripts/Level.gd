extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0 # 0 = edit 1 = play
var complete = false
export(String) var levelID = "0"

onready var levelUI = get_node("LevelUI")
onready var timer = get_node("Cycle Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	Edit()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Global.complete = complete
	
func _physics_process(_delta):
	pass
	
func Play():
	Global.soundManager.play_sound_PlayLevel()
	get_tree().call_group("Laser","Play")
	Global.playing = true
	timer.start()
	
func Edit():
	Global.soundManager.play_sound_StopLevel()
	get_tree().call_group("Beam", "queue_free")
	Global.playing = false
	timer.stop()
	complete = false
	

func _on_Cycle_Timer_timeout():
	timer.start()
	get_tree().call_group("Beam", "bounce")
	get_tree().call_group("Laser Absorber", "shoot")

func _on_Goal_LevelComplete():
	Global.soundManager.play_sound_Win()
	complete = true
	levelUI._Level_Complete()
	Saving.updateLevelCompleted(levelID)
	

func play_pressed():
	if state == 0:
		state = 1
		Play()		
		print("play")
	elif state == 1:
		state = 0
		Edit()
		print("edit")
