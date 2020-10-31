extends Node

var pointerTranslation
var debug = false
var playing = false
var currentScene

var settings = load("res://Menu/Settings.tscn")
var levelSelect = load("res://Menu/Level Select.tscn")
var tabsResource = load("res://Menu/Tabs.tscn")
var soundManagerResource = load("res://Sounds/SoundManager.tscn")
var admobResource = load("res://Ads/AdMob.tscn")
var tabs
var soundManager
var admob

var showAds = true

var camera_sensitivity = 0.5
var music = true
var sound_effects =  true

signal tabChanged


# Called when the node enters the scene tree for the first time.
func _ready():
	pointerTranslation = Vector3(0,0,0)
	currentScene = get_tree().get_root().get_node("1")
	create_adMob()
	create_tabs()
	create_soundManager()
	loadAds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func loadAds() -> void:
	yield(get_tree(), "idle_frame")
	admob.load_banner()
	#admob.load_interstitial()
	admob.load_rewarded_video()
	
func create_adMob():
	admob = admobResource.instance()
	get_parent().call_deferred("add_child", admob)
	
func create_tabs():
	tabs = tabsResource.instance()
	get_parent().call_deferred("add_child", tabs)	
	emit_signal("tabChanged")
	
func create_soundManager():
	soundManager = soundManagerResource.instance()
	get_parent().call_deferred("add_child", soundManager)	

func _input(event):
	if event.is_action_pressed("debug"):
		debug = !debug
			
func load_level(levelPath):
	tabs.set_current_tab(0)
	var level = load(levelPath)
	print("Loading level: " + levelPath)
	var levelInstance = level.instance()
	currentScene.queue_free()
	get_parent().add_child(levelInstance)
	currentScene = levelInstance
	
	
func load_next_level(currentLevelPath, currentLevelName):
	print ("currentLevelPath: " + currentLevelPath)
	print ("currentLevelName: " + currentLevelName)
	
	var nextLevelNum = int(currentLevelName.replace(".tscn",""))
	nextLevelNum += 1
	
	var nextLevelPath = currentLevelPath
	nextLevelPath = nextLevelPath.replace(currentLevelName + ".tscn", "")
	nextLevelPath = nextLevelPath + str(nextLevelNum) + ".tscn"
	
	print ("nextLevelPath: " + nextLevelPath)
	
	var file2Check = File.new()
	var doesFileExist = file2Check.file_exists(nextLevelPath)
	
	if doesFileExist:
		load_level(nextLevelPath)
	
	else:
		tabs.set_current_tab(1)
		
	
	
func get_current_tab():
	if get_tree().get_root().get_node_or_null("Tabs") == null:
		return 0
	return get_tree().get_root().get_node("Tabs").currentTab


