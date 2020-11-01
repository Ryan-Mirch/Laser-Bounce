extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var play = get_node("CenterContainer/Play")
onready var pause = get_node("CenterContainer/Pause")
onready var cont = get_node("CenterContainer/Continue")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = Global.connect("tabChanged", self, "setVisibility")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

func _Level_Complete():
	cont.visible = true
	pause.visible = false
	play.visible = false
	

func _on_Continue_pressed():
	if Global.get_current_tab() != 0: return
	Global.load_next_level(get_parent().get_filename(), get_parent().levelID)


func _on_Retry_pressed():
	Global.load_level(get_parent().get_filename())
