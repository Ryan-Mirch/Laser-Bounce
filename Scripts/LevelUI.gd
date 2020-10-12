extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var play = get_node("CenterContainer/Play")
onready var pause = get_node("CenterContainer/Pause")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("tabChanged", self, "setVisibility")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func setVisibility():
	visible = Global.get_current_tab() == 0

func _on_Play_pressed():
	if Global.get_current_tab() != 0: return
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = true
	play.visible = false
	
func _on_Pause_pressed():
	if Global.get_current_tab() != 0: return
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = false
	play.visible = true



