class_name UI_CELL_CLASS
extends Node2D

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


func _ready():
	pos = position.y
	z_index = int(-pos/10.0) + 200
	pos_in = pos
	pos_out = pos + push_dist

func update_solid():
	#if Global.active_color.has(color.darkened(0.0)):
	if cell_solid:
		modulate = color_shaded.darkened(0.3)
		pos = pos_out
	else:
		modulate = color_shaded.darkened(0.5)
		pos = pos_in

func _process(delta):
	position.y = lerp(position.y, pos, delta * slide_speed)
	update_solid()
