extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var message = "enter message here"
export var messageOnBack = false
export(float) var width = 300
export(float) var height = 150

export(Color) var frontColor = Color(0,0,0,1)
export(Color) var backColor = Color(0,0,0,1)

export(Color) var textColor = Color(1,1,1,1)
export(String, FILE) var fontPath
export(float) var fontSize = 25

export(Color) var borderColor = Color(1,1,1,1)
export(float) var borderThickness = 5
export(float) var cornerRadius = 10
export(float) var margin = 15


enum VALIGN { VALIGN_TOP, VALIGN_CENTER, VALIGN_BOTTOM }
enum HALIGN { ALIGN_LEFT, ALIGN_CENTER, ALIGN_RIGHT }

export(VALIGN) var vAlign = VALIGN.VALIGN_CENTER
export(HALIGN) var hAlign = HALIGN.ALIGN_CENTER


onready var frontMesh = get_node("Front")
onready var frontViewport = get_node("Front/GUI")
onready var frontBackground = get_node("Front/GUI/Front Background")
onready var frontLabel = get_node("Front/GUI/Front Background/Front Label")

onready var backMesh = get_node("Back")
onready var backViewport = get_node("Back/GUI")
onready var backBackground = get_node("Back/GUI/Back Background")
onready var backLabel = get_node("Back/GUI/Back Background/Back Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	$"Guide".queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup():
	setText(message)
	setMesh()
	setViewport()
	setFrontBackground()
	setBackBackground()
	setFont()
	
	
	
func setText(text):
	frontLabel.text = text
	
	if messageOnBack:
		backLabel.text = text
		
	
func setMesh():
	frontMesh.mesh = PlaneMesh.new()	
	frontMesh.mesh.size.x = width/100
	frontMesh.mesh.size.y = (height/100)
	
	backMesh.mesh = PlaneMesh.new()
	backMesh.mesh.size.x = width/100
	backMesh.mesh.size.y = (height/100)
	backMesh.mesh.flip_faces = true
	
	if OS.get_name() == "Android":
		frontMesh.mesh.size.y = frontMesh.mesh.size.y * 1.5
		backMesh.mesh.size.y = backMesh.mesh.size.y * 1.5
	
func setViewport():
	frontViewport.size.x = width
	frontViewport.size.y = height
	
	backViewport.size.x = width
	backViewport.size.y = height
	
func setFont():
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load(fontPath)
	dynamic_font.size = fontSize
	dynamic_font.outline_size = 0
	dynamic_font.outline_color = Color( 0, 0, 0, 1 )
	
	frontLabel.rect_size.x = width
	frontLabel.rect_size.y = height
	frontLabel.valign = vAlign
	frontLabel.align = hAlign
	frontLabel.margin_bottom = height - margin
	frontLabel.margin_top = margin
	frontLabel.margin_left = margin
	frontLabel.margin_right = width - margin
	frontLabel.add_font_override("font", dynamic_font)
	frontLabel.add_color_override("font_color", textColor)
	
	if messageOnBack:
		backLabel.rect_size.x = width
		backLabel.rect_size.y = height
		backLabel.valign = vAlign
		backLabel.align = hAlign
		backLabel.margin_bottom = height - margin
		backLabel.margin_top = margin
		backLabel.margin_left = margin
		backLabel.margin_right = width - margin
		backLabel.add_font_override("font", dynamic_font)
		backLabel.add_color_override("font_color", textColor)
	


func setFrontBackground():
	frontBackground.rect_size.x = width
	frontBackground.rect_size.y = height
	
	var new_style = StyleBoxFlat.new()
	new_style.set_bg_color(frontColor)
	new_style.set_border_color(borderColor)
	
	new_style.set_border_width_all(borderThickness)	
	new_style.set_corner_radius_all(cornerRadius)
	
	frontBackground.set('custom_styles/panel', new_style)
	
func setBackBackground():
	backBackground.rect_size.x = width
	backBackground.rect_size.y = height
	
	var new_style = StyleBoxFlat.new()
	new_style.set_bg_color(backColor)
	new_style.set_border_color(borderColor)
	
	new_style.set_border_width_all(borderThickness)
	new_style.set_corner_radius_all(cornerRadius)
	
	backBackground.set('custom_styles/panel', new_style)
