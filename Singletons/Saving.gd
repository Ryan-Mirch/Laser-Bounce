extends Node

var saveDataFile = "user://saveDataFile.save"

var hintCount = 0
var showAds
var enableSound
var enableMusic
var enableShadows
var camera_sensitivity = 0.25
var bounce_speed = 0.35
var lasersEquipped = {}
var laserSoundsEquipped = {}
var backgroundsEquipped = {}
var tilesEquipped = {}
var levelCompleted = {}
var mostRecentLevelPath = "res://Levels/Tutorial/1.tscn"


signal saveDataUpdated
signal saveDataReset
signal dataLoaded

func _ready():
	loadData()
	initializeSaveData()
	updateSaveData()
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func updateSaveData():
	var f = File.new()
	f.open(saveDataFile, File.WRITE)
	f.store_var(hintCount)
	f.store_var(showAds)
	f.store_var(enableSound)
	f.store_var(enableMusic)
	f.store_var(enableShadows)
	f.store_var(camera_sensitivity)
	f.store_var(bounce_speed)
	f.store_var(levelCompleted)
	f.store_var(lasersEquipped)
	f.store_var(laserSoundsEquipped)
	f.store_var(backgroundsEquipped)
	f.store_var(tilesEquipped)
	f.store_var(mostRecentLevelPath)
	
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
		enableShadows = f.get_var()
		camera_sensitivity = f.get_var()
		bounce_speed = f.get_var()
		levelCompleted = f.get_var()
		lasersEquipped = f.get_var()
		laserSoundsEquipped = f.get_var()
		backgroundsEquipped = f.get_var()
		tilesEquipped = f.get_var()
		mostRecentLevelPath = f.get_var()
		f.close()
	
	emit_signal("dataLoaded")
	
func initializeSaveData():
	if !hintCount: hintCount = 0
	if showAds == null: showAds = true
	if enableSound == null: enableSound = true
	if enableMusic == null: enableMusic = true
	if enableShadows == null: enableShadows = true
	if !camera_sensitivity: camera_sensitivity = 0.5
	if !bounce_speed: bounce_speed = 0.4
	if !levelCompleted: levelCompleted = {}
	if !lasersEquipped: lasersEquipped = {}
	if !laserSoundsEquipped: laserSoundsEquipped = {}
	if !backgroundsEquipped: backgroundsEquipped = {}
	if !tilesEquipped: tilesEquipped = {}
	if !mostRecentLevelPath: mostRecentLevelPath = "res://Levels/Tutorial/1.tscn"

func updateLevelCompleted(levelID, b):
	levelCompleted[levelID] = b	
	updateSaveData()
	
func resetSaveData():
	hintCount = 0
	showAds = true
	enableSound = true
	enableMusic = true
	enableShadows = true
	camera_sensitivity = 0.25
	bounce_speed = 0.35
	levelCompleted.clear()
	lasersEquipped.clear()
	laserSoundsEquipped.clear()
	backgroundsEquipped.clear()
	tilesEquipped.clear()
	mostRecentLevelPath.clear()
	
	var dir = Directory.new()
	dir.remove(saveDataFile)
	initializeSaveData()
	updateSaveData()
	emit_signal("saveDataReset")
	
	
func getLevelsCompleted():
	var result = 0
	
	for i in levelCompleted:
		if levelCompleted[i]:
			result = result + 1
	return result
