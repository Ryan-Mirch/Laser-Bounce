extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var play = get_node("CenterContainer/Play")
onready var pause = get_node("CenterContainer/Pause")
onready var cont = get_node("CenterContainer/Continue")
onready var levelCompleteMessage = get_node("Level Completed")
onready var hintButton = get_node("Hint/Button")
onready var retryButton = get_node("CenterContainer2/Retry")
onready var transitionEffect = get_node("Transition Effect")

var levelComplete = false
var retryDisabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = Global.connect("tabChanged", self, "tabChanged")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func tabChanged():
	visible = Global.get_current_tab() == 0
	if Global.get_current_tab() != 0 and Global.playing and !Global.complete:
		var Level = get_parent()
		Level.play_pressed()
		pause.visible = false
		play.visible = true
		hintButton.disabled = false

func _on_Play_pressed():
	if Global.get_current_tab() != 0: return
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = true
	play.visible = false
	hintButton.disabled = true
	
func _on_Pause_pressed():
	if Global.get_current_tab() != 0: return
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = false
	play.visible = true
	hintButton.disabled = false

func _Level_Complete():
	cont.visible = true
	pause.visible = false
	play.visible = false
	levelComplete = true
	levelCompleteMessage.visible = true
	#transitionEffect.levelCompleted()
	

func _on_Continue_pressed():
	if Global.get_current_tab() != 0: return
	
	transitionEffect.transition()
	yield(transitionEffect.ap, "animation_finished")
	Global.load_next_level(get_parent().get_filename(), get_parent().levelID)


func _on_Retry_pressed():
	if transitionEffect.ap.current_animation != "Fade":
		Global.load_level(get_parent().get_filename())

