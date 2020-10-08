extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var play = get_node("CenterContainer/Play")
onready var pause = get_node("CenterContainer/Pause")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_Play_pressed():
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = true
	play.visible = false
	
func _on_Pause_pressed():
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = false
	play.visible = true

func _on_Level_Select_pressed():
	Global.open_level_select()

func _on_Settings_pressed():
	Global.open_settings()



