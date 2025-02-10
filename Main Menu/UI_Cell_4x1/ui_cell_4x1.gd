extends UI_CELL_CLASS
@onready var label = $Label
@onready var Master = get_tree().root.get_node("Main Menu")

var palette: Array[Color]

func _ready():
	match index:
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
	
	width = 120*4
	height = 120
	super._ready()
	var pos_temp = pos_in
	pos_in = pos_out
	pos_out += (pos_temp - pos_out)/5
	
	label.text = "" if index.contains("Palette")  else index
	
	color = Global.color_palette[0]
	color_shaded = color
	modulate = color_shaded.darkened(0.5)

func _process(delta):
	super._process(delta)
	if !cell_solid: return
	Global.active_color.clear()
	
	if index.contains("Palette"): index = "Palette"
	match index:
		"Customize":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Master.page_container.next_page = 2
		"Palette":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				print(name)
				Global.color_palette = palette
				Master.page_container.next_page = 1
		"Leaderboard":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Master.page_container.next_page = 3
			#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				#var leaderboard_scene = preload(Global.REFS.Leaderboard)
				#var leaderboard_instance = leaderboard_scene.instantiate()
				#get_parent().get_parent().add_child(leaderboard_instance)
		"Exit":
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				get_tree().quit()
