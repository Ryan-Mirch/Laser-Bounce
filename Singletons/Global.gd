extends Node

var tabs
var admob
var iap
var currentScene
var currencyDisplay
var debugLabel

var pointerTranslation
var debug = false
var playing = false
var complete = false


var settings = load("res://Menu/Settings.tscn")
var levelSelect = load("res://Menu/Level Select.tscn")


signal tabChanged


# Called when the node enters the scene tree for the first time.
func _ready():
	Saving.connect("saveDataUpdated",self,"hideAds")
	Saving.connect("dataLoaded",self,"hideAds")
	
	pointerTranslation = Vector3(0,0,0)
	loadAds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func loadAds() -> void:
	yield(get_tree(), "idle_frame")
	admob.load_banner()
	#admob.load_interstitial()
	admob.load_rewarded_video()

func hideAds():
	if !Saving.showAds:
		admob.hide_banner()

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
		#reloads current level then sends you to level select screen
		load_level(currentLevelPath) 
		tabs.set_current_tab(1)
		
		
	
	
func get_current_tab():
	if Global.tabs == null:
		return 0
	return Global.tabs.currentTab


