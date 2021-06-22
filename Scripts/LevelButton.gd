extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var label = get_node("TextureButton/Level")
onready var levelCompletedIcon = get_node("LevelCompletedIcon")

export (String, FILE) var levelPath
export (String) var levelName
export (String) var levelID

var completed = false
var isPressed = false
var deadZone = 20
var posOfClickStart

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
	if !Saving.levelCompleted.has(levelPath):
		Saving.levelCompleted[levelPath] = false	
		Saving.updateSaveData()
	

func updateCompletedIcon():
	initializeSaveData()
	levelCompletedIcon.visible = Saving.levelCompleted[levelPath]
	


func setLabelText():
	label.text = levelName


func _on_TextureButton_gui_input(event):
	if event.is_action_released("grab") and isPressed:
		isPressed = false
		
		if posOfClickStart.distance_to(get_viewport().get_mouse_position()) <= deadZone:
			Global.load_level(levelPath)
			
	if event.is_action_pressed("grab") and !isPressed:
		posOfClickStart = get_viewport().get_mouse_position()
		isPressed = true	
	
