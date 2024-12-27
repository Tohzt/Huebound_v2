class_name CellClass
extends Node2D

@onready var sprite = $Sprite2D
@onready var cell: StaticBody2D = $StaticBody2D

var hue: HueClass
var color_index: int
var cell_solid = false
var update_solid = true
var cell_grid_pos: Vector2

func _ready():
	hue = get_tree().get_first_node_in_group("Hue")
	sprite.frame = color_index
	if !cell_solid: sprite.frame += 10
	var cell_x_pos = floor(global_position.x / Settings.cell_size)
	var cell_y_pos = abs(floor(global_position.y / Settings.cell_size)+1)
	cell_grid_pos = Vector2(cell_x_pos, cell_y_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update_solid:
		update_solid = false
		if Global.active_color.has(color_index):
			cell_solid = true
			sprite.frame = color_index
			sprite.modulate.a = 1.0
			if cell_grid_pos == hue.hue_grid_pos:
				#printt(cell_grid_pos, hue.hue_grid_pos)
				hue.death_to_heuy()
		else:
			cell_solid = false
			sprite.frame = color_index + 10
			sprite.modulate.a = 0.5
	
	cell.set_collision_layer_value(1, cell_solid)
