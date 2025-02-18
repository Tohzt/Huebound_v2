class_name UI_CELL_CLASS
extends Node2D

@export var index: String = ""
@export var col_index: int = 0
var offset = 0

@onready var origin = position
var width = 120
var height = 120

var pos_in = position.y
var pos_out = position.y + 30
var pos = position.y
var color: Color
var color_shaded: Color
var cell_solid = false
var slide_speed = randf_range(5.0, 25.0)
var push_dist = 60
var btn_active = false  # New flag for button cooldown


func _update_color():
	var cells = get_tree().get_nodes_in_group("UI_Cells")
	for cell in cells:
		if cell.index and !cell.index.contains("Palette"):
			print(cell.index)
			cell._set_color()

func _set_color():
		color = Global.color_palette[col_index]
		#color_shaded = color.darkened(0.5)

func _ready():
	pos = position.y
	z_index = int(-pos/10.0) + 200
	pos_in = pos
	pos_out = pos + push_dist

func update_solid():
	#if Global.active_color.has(color.darkened(0.0)):
	if cell_solid:
		#modulate = color_shaded.darkened(0.3)
		pos = pos_out
	else:
		#modulate = color_shaded.darkened(0.5)
		pos = pos_in

func _process(delta):
	offset = abs(int(position.y - pos_in))
	position.y = lerp(position.y, pos, delta * slide_speed)
	update_solid()

# New function to reset the button
func reset_button():
	btn_active = false

func activate_button():
	btn_active = true
	# Create and start a one-shot timer
	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(reset_button)
