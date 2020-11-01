extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var label = get_node("Level")
onready var levelCompletedIcon = get_node("LevelCompletedIcon")

export (String, FILE) var levelPath
export (String) var levelName

# Called when the node enters the scene tree for the first time.
func _ready():
	Saving.connect("saveDataUpdated",self,"updateCompletedIcon")
	updateCompletedIcon()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	
func updateCompletedIcon():
	if Saving.levelCompleted.has(levelName):
		levelCompletedIcon.visible = Saving.levelCompleted[levelName]
	else: levelCompletedIcon.visible = false


func setLabelText():
	label.text = levelName


func _on_TextureButton_pressed():
	Global.load_level(levelPath)


