class_name ItemClass
extends Node2D
@onready var sprite = $Sprite2D
@onready var area = $Area2D

var power: String = ""
var item_grid_pos: Vector2
var toggle_visible = false

func _ready():
	power = ["triple_jump","wall_cling", "shuffle", "random_swap"].pick_random()
	if power == "wall_cling":
		$Sprite2D.frame = 1
	if power == "shuffle":
		$Sprite2D.frame = 2
	if power == "random_swap":
		$Sprite2D.frame = 3
	var item_x_pos = floor((global_position.x - Settings.cell_offset) / Settings.cell_size)
	var item_y_pos = abs(floor((global_position.y + Settings.cell_offset) / Settings.cell_size))
	item_grid_pos = Vector2(item_x_pos, item_y_pos-1)

func _on_area_2d_body_entered(Hue): 
	if !Hue: return
	if Hue.is_in_group("Hue"):
		Hue.power = power
		queue_free()

func _process(_delta):
	sprite.z_index = int(item_grid_pos.y+1)

	
func check_visible():
	var cells = get_tree().get_nodes_in_group("Cell")
	for cell: CellClass in cells:
		if item_grid_pos == cell.cell_grid_pos:
			if Global.active_color.has(cell.color):
				sprite.hide()
				area.set_collision_mask_value(1, false)
			else:
				sprite.show()
				area.set_collision_mask_value(1, true)
	
