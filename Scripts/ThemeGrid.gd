extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var button = load("res://UI/LevelButton.tscn")

export(String, DIR) var themePath


# Called when the node enters the scene tree for the first time.
func _ready():
	createButtons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a < b:
			return true
		return false

func createButtons():
	var levelNames = list_files_in_directory(themePath)
	var levelNamesAsInts = []
	
	for levelName in levelNames:
		levelNamesAsInts.push_front(int(levelName))
	
	levelNamesAsInts.sort_custom(MyCustomSorter, "sort_ascending")
	print(levelNamesAsInts)
	
	for levelName in levelNamesAsInts:
		var levelPath = themePath + "/" + str(levelName) + ".tscn"
		var buttonInstance = button.instance()
		buttonInstance.levelPath = levelPath
		buttonInstance.levelName = str(levelName).replace(".tscn", "")
		
		add_child(buttonInstance)

func list_files_in_directory(_path):
	var files = []
	var dir = Directory.new()
	dir.open(themePath)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	print(files)
	return files
