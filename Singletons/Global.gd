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

var interTime = 0
var interTargetTime = 300


var settings = load("res://Menu/Settings.tscn")
var levelSelect = load("res://Menu/Level Select.tscn")


signal tabChanged


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("tabChanged")
	var _x = Saving.connect("saveDataUpdated",self,"manageAds")
	var _y = Saving.connect("dataLoaded",self,"manageAds")
		
	pointerTranslation = Vector3(0,0,0)
	loadAds()
	
	yield(get_tree(), "idle_frame")
	manageAds()
	
	load_level("res://Levels/Tutorial/1.tscn")
	admob.connect("banner_loaded", self, "make_room_for_Banner")
	
func make_room_for_Banner():
	if Saving.showAds:
		setBannerOffset(Global.admob.get_banner_offset())
	

func setBannerOffset(h):
	get_tree().call_group("offsetForBanner","setMarginTop", h)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interTime = interTime + delta
	
func loadAds() -> void:
	yield(get_tree(), "idle_frame")
	admob.load_banner()
	admob.load_interstitial()
	
func showAds():
	yield(get_tree(), "idle_frame")
	admob.show_banner()
	
func showInterstitial():
	if !Saving.showAds: return
	if interTime >= interTargetTime:
		print("Interstitial Shown")
		interTime = 0
		admob.show_interstitial()

func manageAds():
	if !Saving.showAds:
		admob.hide_banner()
		setBannerOffset(0)
	else:
		admob.show_banner()
		setBannerOffset(Global.admob.get_banner_offset())

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
	
	showInterstitial()
	
	
func load_next_level(currentLevelPath):	
	
	var nextLevelPath = currentScene.nextLevelPath
		
	print ("nextLevelPath: " + nextLevelPath)
	
	if nextLevelPath != "":
		print("loading next level")
		load_level(nextLevelPath)
	
	else:
		print("loading current level")
		#reloads current level then sends you to level select screen
		load_level(currentLevelPath) 
		tabs.set_current_tab(1)
		
		
	
	
func get_current_tab():
	if Global.tabs == null:
		return 0
	return Global.tabs.currentTab


