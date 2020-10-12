extends Node

var pointerTranslation
var debug = false
var playing = false
var currentScene

var settings = load("res://Menu/Settings.tscn")
var levelSelect = load("res://Menu/Level Select.tscn")
var tabs = load("res://Menu/Tabs.tscn")
var tabsInstance

signal tabChanged


# Called when the node enters the scene tree for the first time.
func _ready():
	pointerTranslation = Vector3(0,0,0)
	currentScene = get_tree().get_root().get_node("1")
	
	tabsInstance = tabs.instance()
	get_parent().call_deferred("add_child", tabsInstance)
	
	emit_signal("tabChanged")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("debug"):
		debug = !debug
			
func load_level(levelID):
	tabsInstance.set_current_tab(0)
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
	
func get_current_tab():
	if get_tree().get_root().get_node_or_null("Tabs") == null:
		return 0
	return get_tree().get_root().get_node("Tabs").currentTab

