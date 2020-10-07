extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0 # 0 = edit 1 = play
var complete = false

export(String) var nextLevel

onready var victory = get_node("Victory")
onready var timer = get_node("Cycle Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	Edit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(_delta):
	pass

	
		
func Play():
	get_tree().call_group("Laser","Play")
	Global.playing = true
	timer.start()
	
func Edit():
	get_tree().call_group("Beam", "queue_free")
	Global.playing = false
	timer.stop()
	victory.visible = false
	complete = false
	

func _on_Cycle_Timer_timeout():
	timer.start()
	get_tree().call_group("Beam", "bounce")


func _on_Goal_LevelComplete():
	complete = true
	victory.visible = true


func back_pressed():
	Global.load_menu()
	
func next_pressed():
	print(name)
	Global.load_level(nextLevel)

func play_pressed():
	if state == 0:
		state = 1
		Play()		
		print("play")
	elif state == 1:
		state = 0
		Edit()
		print("edit")
