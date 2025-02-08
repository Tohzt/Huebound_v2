extends UI_CELL_CLASS

@export var button_index: int

signal start_pressed

func _ready():
	width = 120*4
	height = 120*2
	super._ready()
	if button_index:
		var pos_temp = pos_in
		pos_in = pos_out
		pos_out += (pos_temp - pos_out)/5
		#pos_in = pos_in + push_dist*0.5
		#pos_out = pos_out - push_dist*0.25
		pass
		#pos_in = pos_out
		#pos_out += push_dist
		#pos += push_dist
		
	color = Global.palette_color[button_index-1]
	color_shaded = color
	modulate = color_shaded.darkened(0.5)
	
	# Connect to the START button's signal
	var start_button = get_tree().get_first_node_in_group("start_button")
	if start_button:
		start_button.start_pressed.connect(_on_start_pressed)

func _on_start_pressed():
	hide()

func _process(delta):
	super._process(delta)
	if !cell_solid: return
	Global.active_color.clear()
	if button_index == 1 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		start_pressed.emit()
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_file(Global.REFS.Game)
