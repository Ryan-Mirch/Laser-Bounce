extends Node

var saveDataFile = "user://saveDataFile.save"

var hintCount = 0
var showAds = true
var enableSound = true
var enableMusic = true
var camera_sensitivity = 0.25

var lasersEquipped = {}
var laserSoundsEquipped = {}
var backgroundsEquipped = {}
var tilesEquipped = {}

var levelCompleted = {}


signal saveDataUpdated
signal saveDataReset
signal dataLoaded

func _ready():
	loadData()
	initializeSaveData()
	updateSaveData()
		
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
	f.store_var(lasersEquipped)
	f.store_var(laserSoundsEquipped)
	f.store_var(backgroundsEquipped)
	f.store_var(tilesEquipped)
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
		lasersEquipped = f.get_var()
		laserSoundsEquipped = f.get_var()
		backgroundsEquipped = f.get_var()
		tilesEquipped = f.get_var()
		f.close()
	
	emit_signal("dataLoaded")
	
func initializeSaveData():
	if !hintCount: hintCount = 0
	if !showAds: showAds = true
	if !enableSound: enableSound = true
	if !enableMusic: enableMusic = true
	if !camera_sensitivity: camera_sensitivity = 0.5
	if !levelCompleted: levelCompleted = {}
	if !lasersEquipped: lasersEquipped = {}
	if !laserSoundsEquipped: laserSoundsEquipped = {}
	if !backgroundsEquipped: backgroundsEquipped = {}
	if !tilesEquipped: tilesEquipped = {}

func updateLevelCompleted(levelID):
	levelCompleted[levelID] = true	
	updateSaveData()
	
func resetSaveData():
	hintCount = 0
	showAds = true
	enableSound = true
	enableMusic = true
	camera_sensitivity = 0.25
	levelCompleted.clear()
	lasersEquipped.clear()		
	laserSoundsEquipped.clear()	
	backgroundsEquipped.clear()	
	tilesEquipped.clear()	
	
	updateSaveData()
	emit_signal("saveDataReset")
