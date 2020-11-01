extends Node

var saveDataFile = "user://saveDataFile.save"

var hintCount = 0
var showAds = true
var enableSound = true
var enableMusic = true
var camera_sensitivity = 0.25
var levelCompleted = {}

signal saveDataUpdated
signal dataLoaded

func _ready():
	loadData()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func updateSaveData():
	var f = File.new()
	f.open(saveDataFile, File.WRITE)
	f.store_var(hintCount)
	f.store_var(showAds)
	f.store_var(enableSound)
	f.store_var(enableMusic)
	f.store_var(camera_sensitivity)
	f.store_var(levelCompleted)
	f.close()
	emit_signal("saveDataUpdated")
	
func loadData():
	var f = File.new()
	if f.file_exists(saveDataFile):
		f.open(saveDataFile, File.READ)
		hintCount = f.get_var()
		showAds = f.get_var()
		enableSound = f.get_var()
		enableMusic = f.get_var()
		camera_sensitivity = f.get_var()
		levelCompleted = f.get_var()
		f.close()
		
	emit_signal("dataLoaded")

func updateLevelCompleted(levelID):
	levelCompleted[levelID] = true	
	updateSaveData()
