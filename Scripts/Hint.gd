extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var countLabel = get_node("Count")
onready var hintPopup = get_node("../Hint Popup")


export var startingHints = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	Settings.hintCount = startingHints

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func giveHint():
	Settings.hintCount -= 1
	pass

func _on_Button_pressed():
	if Settings.hintCount == 0:
		hintPopup.popup()	
		return
	giveHint()

func _on_Button_Yes_pressed():	
		if Settings.admob:
			Settings.admob.resize()
			Settings.admob.showRewardedVideo()
		hintPopup.hide()

func _on_Button_No_pressed():
	hintPopup.hide()
