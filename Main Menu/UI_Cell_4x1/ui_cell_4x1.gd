extends UI_CELL_CLASS
@onready var label = $Label

@export var button_index: int

func _ready():
	width = 120*4
	height = 120
	super._ready()
	if button_index:
		#pos_in = pos_out
		#pos_out += push_dist
		#pos += push_dist
		match button_index:
			2: label.text = "Settings"
			3: label.text = "Score Board"
			4: label.text = "Exit"
		
	color = Global.palette_color[button_index-1]
	color_shaded = color
	modulate = color_shaded.darkened(0.5)


@onready var settings_options = $"../../Container/Settings Options"
func _process(delta):
	super._process(delta)
	if !cell_solid: return
	Global.active_color.clear()
	match button_index:
		1:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Global.active_color.clear()
				get_tree().change_scene_to_file(Global.REFS.Game)
		2:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				settings_options.show()
		3:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				settings_options.hide()
				var leaderboard_scene = preload(Global.REFS.Leaderboard)
				var leaderboard_instance = leaderboard_scene.instantiate()
				get_parent().get_parent().add_child(leaderboard_instance)
		4:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				get_tree().quit()
