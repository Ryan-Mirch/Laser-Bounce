extends Node

var pointerTranslation
var debug = false
var playing = false
var currentScene



# Called when the node enters the scene tree for the first time.
func _ready():
	pointerTranslation = Vector3(0,0,0)
	currentScene = get_tree().get_root().get_node("Main Menu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("debug"):
		debug = !debug
			
func load_level(levelID):
	var level = load("res://Levels/" + levelID + ".tscn")
	var levelInstance = level.instance()
	currentScene.queue_free()
	get_parent().add_child(levelInstance)
	currentScene = levelInstance
	
func load_menu():
	var scene = load("res://Menu/Main Menu.tscn")
	var sceneInstance = scene.instance()
	currentScene.queue_free()
	get_parent().add_child(sceneInstance)
	currentScene = sceneInstance
