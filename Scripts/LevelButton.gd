extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var label = get_node("CenterContainer/Level")
export (String) var level

# Called when the node enters the scene tree for the first time.
func _ready():
	set_level(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_level(l):
	level = l
	label.text = level


func _on_TouchScreenButton_pressed():
	if get_tree().get_nodes_in_group("Settings").size() != 0:
		return
		
	Global.load_level(level)
