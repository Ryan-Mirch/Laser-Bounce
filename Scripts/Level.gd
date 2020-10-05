extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0 # 0 = edit 1 = play

onready var timer = get_node("Cycle Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	Edit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	pass


func _on_Play_Button_pressed():
	if state == 0:
		state = 1
		Play()		
		print("play")
	elif state == 1:
		state = 0
		Edit()
		print("edit")
		
func Play():
	get_tree().call_group("Laser","Play")
	Global.playing = true
	timer.start()
	
func Edit():
	get_tree().call_group("Beam", "queue_free")
	Global.playing = false
	timer.stop()
	

func _on_Cycle_Timer_timeout():
	timer.start()
	get_tree().call_group("Beam", "bounce")
