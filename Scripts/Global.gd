extends Node

var pointerTranslation
var debug = false
var playing = false
var currentScene

var settings = load("res://Menu/Settings.tscn")
var levelSelect = load("res://Menu/Level Select.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pointerTranslation = Vector3(0,0,0)
	currentScene = get_tree().get_root().get_node("1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("debug"):
		debug = !debug
			
func load_level(levelID):
	for n in get_tree().get_nodes_in_group("Level Select"):
		n.queue_free()
	
	if currentScene.name == levelID: return
	var level = load("res://Levels/" + levelID + ".tscn")
	var levelInstance = level.instance()
	currentScene.queue_free()
	get_parent().add_child(levelInstance)
	currentScene = levelInstance
	
func load_next_level(levelString):
	var levelInt = int(levelString)
	levelInt += 1
	
	var level = load("res://Levels/" + str(levelInt) + ".tscn")
	var levelInstance = level.instance()
	currentScene.queue_free()
	get_parent().add_child(levelInstance)
	currentScene = levelInstance
	
func open_level_select():
	var instance = levelSelect.instance()
	get_parent().add_child(instance)
	
func open_settings():
	var instance = settings.instance()
	get_parent().add_child(instance)
