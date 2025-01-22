class_name CellClass
extends Node2D
@onready var label = $Label

#@onready var sprite = $Sprite2D
@onready var block_sprite: Sprite2D = $BlockSprite
@onready var cell: StaticBody2D = $StaticBody2D
var pos_in = position.y
var pos_out = position.y + 60
@onready var pos = position.y
var hue: HueClass
var color: Color
var color_shaded: Color
var cell_solid = false
var cell_grid_pos: Vector2
var slide_speed = randf_range(5.0, 15.0)


func _ready():
	pos_in = position.y
	pos_out = position.y + 60
	hue = get_tree().get_first_node_in_group("Hue")
	color = Global.palette_color.pick_random()
	color_shaded = color
	block_sprite.modulate = color_shaded.darkened(0.3)
	var cell_x_pos = floor(global_position.x / Settings.cell_size)
	var cell_y_pos = abs(floor((global_position.y + 60) / Settings.cell_size)+1)
	cell_grid_pos = Vector2(cell_x_pos, cell_y_pos)


func _process(delta):
	block_sprite.z_index = int(cell_grid_pos.y+1)
	if !cell_solid:
		block_sprite.z_index = int(cell_grid_pos.y-1)
	#block_sprite.z_index = -int(position.y/100)
	#if !cell_solid:
		#block_sprite.z_index = -int(position.y/100) - 300/100

	#block_sprite.z_index = abs(position.y) / 10
	
	#label.text = "(" + str(cell_grid_pos.x)+","+str(cell_grid_pos.y) +")"
	label.text = "(" + str(block_sprite.z_index) +")"
	position.y = lerp(position.y, pos, delta * slide_speed)
	
	cell.set_collision_layer_value(1, cell_solid)

func update_solid():
	if Global.active_color.has(color.darkened(0.0)):
		block_sprite.modulate = color_shaded.darkened(0.0)
		cell_solid = true
		pos = pos_out
		if cell_grid_pos == hue.hue_grid_pos:
			hue.death_to_heuy()
	else:
		block_sprite.modulate = color_shaded.darkened(0.3)
		cell_solid = false
		pos = pos_in
