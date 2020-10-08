extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	var Level = get_parent()
	Level.play_pressed()

func _on_Level_Select_pressed():
	Global.open_level_select()

func _on_Settings_pressed():
	Global.open_settings()
