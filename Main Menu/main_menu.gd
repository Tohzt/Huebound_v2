extends Control
@onready var ui_cells = $"UI Cells"
@onready var view_size = get_viewport().get_size()*2

func _ready():
	#_build_grid()
	pass

func _build_grid():
	var btn_start = [7,8,9,10,13,14,15,16]
	var btn_settings = [25,26,27,28,31,32,33,34]
	var btn_leaderboard = [43,44,45,46,49,50,51,52]
	var btn_exit = []
	var num_rows = 11
	var num_cols = 6
	var index = 0
	for i in range(num_rows):
		for j in range(num_cols):
			var ui_cell = Global.REFS.UI_Cell.instantiate()
			ui_cell.index = index
			if btn_start.has(index):
				ui_cell.button_index = 1
			if btn_settings.has(index):
				ui_cell.button_index = 2
			if btn_leaderboard.has(index):
				ui_cell.button_index = 3
			if btn_exit.has(index):
				ui_cell.button_index = 1
			ui_cell.position = Vector2(j * ui_cell.size, i * ui_cell.size)
			ui_cells.add_child(ui_cell)
			index+=1

func _process(_delta):
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
				var mouse_in = mouse_pos.x > cell.origin.x and\
								mouse_pos.x < cell.origin.x + cell.width and\
								mouse_pos.y > cell.origin.y - 60 and\
								mouse_pos.y < cell.origin.y + cell.height - 60
				if mouse_in: 
					cell.cell_solid = true
					#Global.active_color.clear()
					#Global.active_color.append(cell.color)
	else:
		Global.active_color.clear()

func _on_btn_start_pressed():
	pass
	#Global.active_color.clear()
	#get_tree().change_scene_to_file(Global.REFS.Game)


func _on_btn_exit_pressed():
	pass
	#get_tree().quit()
