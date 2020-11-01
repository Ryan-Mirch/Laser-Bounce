extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var countLabel = get_node("Count")
onready var hintPopup = get_node("../Hint Popup")
onready var watchAdButton = get_node("../Hint Popup/VBoxContainer/HBoxContainer/Button Yes")

export var startingHints = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	Saving.hintCount = startingHints
	Global.admob.connect("rewarded", self, "rewardRecieved")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	watchAdButton.disabled = !Global.admob._is_rewarded_video_loaded

func rewardRecieved(currency, amount):
	if currency == "Hint":
		Saving.hintCount += amount

func giveHint():
	Saving.hintCount -= 1
	pass

func _on_Button_pressed():
	if 	Global.playing == true: return
	if Saving.hintCount == 0:
		hintPopup.popup()	
		return
	giveHint()

func _on_Button_Yes_pressed():	
	Global.admob.show_rewarded_video()
	hintPopup.hide()

func _on_Button_No_pressed():
	hintPopup.hide()
