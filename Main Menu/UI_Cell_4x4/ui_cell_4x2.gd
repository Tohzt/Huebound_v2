extends UI_CELL_CLASS
@onready var Master = get_tree().root.get_node("Main Menu")

signal start_pressed

func _ready():
	width = 120*4
	height = 120*2
	super._ready()
	var pos_temp = pos_in
	pos_in = pos_out
	pos_out += (pos_temp - pos_out)/5
	var rng = randi_range(1,3)
	color = Global.color_palette[rng]
	color_shaded = color
	modulate = color_shaded.darkened(0.5)

func _process(delta):
	super._process(delta)
	if !cell_solid: return
	
	Global.active_color.clear()
	if index == "Start" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !TransitionHandler.is_transitioning:
		start_pressed.emit()
		TransitionHandler.is_transitioning = true
		await get_tree().create_timer(2.5).timeout
		#get_tree().change_scene_to_file(Global.REFS.Game)
		TransitionHandler.fade_out(get_tree().current_scene, Global.REFS.Game, 0.1, Color.BLACK)
