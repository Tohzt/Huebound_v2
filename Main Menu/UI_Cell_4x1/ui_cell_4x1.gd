extends UI_CELL_CLASS
@onready var label = $Label
@onready var Master = get_tree().root.get_node("Main Menu")
@onready var cell_1 = $cell_1
@onready var cell_2 = $cell_2
@onready var cell_3 = $cell_3
@onready var cell_4 = $cell_4
@onready var cell_long = $cell_long

var palette: Array[Color]
var update_random = true

func _ready():
	match index:
		"Palette_Default":
			palette = Global.palette_default
		"Palette_1":
			palette = Global.palette_1
		"Palette_2":
			palette = Global.palette_2
		"Palette_3":
			palette = Global.palette_3
		"Palette_4":
			palette = Global.palette_4
		"Palette_5":
			palette = Global.palette_5
		"Palette_6":
			palette = Global.palette_grey
	
	width = 120*4
	height = 120
	super._ready()
	pos_in = pos_out - 100
	pos_out = pos_in + push_dist/2.0
	
	if index.contains("Palette"):
		label.text = ""
		cell_long.hide()
		cell_1.modulate = palette[0]
		cell_2.modulate = palette[1]
		cell_3.modulate = palette[2]
		cell_4.modulate = palette[3]
	else: 
		label.text = index
		cell_long.show()
		_set_color()

func _set_color():
	super._set_color()
	cell_long.modulate = color

func _process(delta):
	super._process(delta)
	position.y = lerp(position.y, pos, delta * slide_speed)
	if name == "UI_Cell_Palette_5": 
		if Master.page_container.next_page == 1:
			update_random = true
		if update_random:
			update_random = false
			palette = [Color(randf(), randf(), randf(), 1), Color(randf(), randf(), randf(), 1), Color(randf(), randf(), randf(), 1), Color(randf(), randf(), randf(), 1)]
			cell_1.modulate = palette[0]
			cell_2.modulate = palette[1]
			cell_3.modulate = palette[2]
			cell_4.modulate = palette[3]
	if !cell_solid or btn_active: return
		
	Global.active_color.clear()
	
	if index.contains("Palette"): 
		index = "Palette"
	match index:
		"Customize":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				activate_button()
				Master.page_container.next_page = 2
		"Palette":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				activate_button()
				Global.color_palette = palette
				_update_color()
				Master.page_container.next_page = 1
		"Leaderboard":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				activate_button()
				Master.page_container.next_page = 3
				var leaderboard_scene = preload(Global.REFS.Leaderboard)
				var leaderboard_instance = leaderboard_scene.instantiate()
				Master.add_child(leaderboard_instance)
		"Exit":
			modulate = Global.palette_grey[0]
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if !OS.has_feature("web"):
					get_tree().quit()
