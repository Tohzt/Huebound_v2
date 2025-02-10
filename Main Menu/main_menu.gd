extends Control
@onready var view_size = get_viewport().get_size()*2
@onready var page_container = $"Page Container"

func _process(_delta):
	_handle_mouse()


func _handle_mouse() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	var mouse_in_view = mouse_pos.x > 0 and\
						mouse_pos.x < view_size.x and\
						mouse_pos.y > 0 and\
						mouse_pos.y < view_size.y
	if mouse_in_view:
		var cells = get_tree().get_nodes_in_group("UI_Cells")
		if cells:
			for cell: UI_CELL_CLASS in cells:
				cell.cell_solid = false
				var mouse_in =  mouse_pos.x > cell.global_position.x and\
								mouse_pos.x < cell.global_position.x + cell.width and\
								mouse_pos.y > cell.global_position.y - 60 and\
								mouse_pos.y < cell.global_position.y + cell.height - 60
				if mouse_in: 
					cell.cell_solid = true
					#Global.active_color.clear()
					#Global.active_color.append(cell.color)
	else:
		Global.active_color.clear()
