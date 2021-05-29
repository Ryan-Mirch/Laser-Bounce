extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var label = get_node("TextureButton/Level")
onready var levelCompletedIcon = get_node("LevelCompletedIcon")

export (String, FILE) var levelPath
export (String) var levelName

var completed = false

# Called when the node enters the scene tree for the first time.
func _ready():	
	var _x = Saving.connect("saveDataUpdated",self,"updateCompletedIcon")
	var _y = Saving.connect("saveDataReset",self,"initializeSaveData")
	initializeSaveData()
	updateCompletedIcon()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	
func initializeSaveData():	
	if !Saving.levelCompleted.has(levelName):
		Saving.levelCompleted[levelName] = false	
		Saving.updateSaveData()
	

func updateCompletedIcon():
	initializeSaveData()
	levelCompletedIcon.visible = Saving.levelCompleted[levelName]
	


func setLabelText():
	label.text = levelName


func _on_TextureButton_pressed():
	Global.load_level(levelPath)
	
func getLevelName():
	return levelName

