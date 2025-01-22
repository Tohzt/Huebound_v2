extends Node2D

@onready var Hue = $Hue

var num_rows = 40
var num_cols = 5
var chunk_shift = 1

func _ready():
	Global.new_record = false
	Global.add_chunk = true
	_build_grid()

func _build_grid():
	# TODO Spawn item into block. Easier to hide when block is active
	if !Global.add_chunk: return
	var yy = num_rows
	var xx = num_cols
	#var cur_cel = 0
	var _freq = Settings.item_frequency
	for y in yy:
		for x in xx:
			#Spawn Block
			var cell = Global.REFS.Cell.instantiate()
			var x_pos =  x*Settings.cell_size + Settings.cell_offset
			var y_pos = -y*Settings.cell_size - Settings.cell_size - Settings.cell_offset*2
			cell.position = Vector2(x_pos, y_pos)
			get_node("Cell Container").add_child(cell)
			
			if y > 1 and randi() % 100 < _freq:
				var item = Global.REFS.Item.instantiate()
				var cell_offset = Vector2(60, -60)
				item.position = cell.position + cell_offset
				get_node("Item Container").add_child(item)
			
	Global.add_chunk = false

func _process(_delta):
	# When player gets close to top, recycle bottom rows
	if Global.height > num_rows - 6:  # Triggers when player is 6 rows from top
		var cells = get_tree().get_nodes_in_group("Cell")
		num_rows += 10  # Increment by 10 rows instead of 1
		for cell: CellClass in cells:
			# Check if cell is in any of the next 10 rows to be recycled
			if cell.cell_grid_pos.y >= chunk_shift and cell.cell_grid_pos.y < chunk_shift + 10:
				# Calculate new row position based on how many rows up it should go
				var row_offset = cell.cell_grid_pos.y - chunk_shift
				cell.position.y = -(num_rows + 1 - (9 - row_offset)) * Settings.cell_size
				cell._ready()
				cell.update_solid()
		chunk_shift += 10  # Increment chunk_shift by 10 instead of 1


func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file(Global.REFS.Start)


func _on_btn_exit_pressed():
	get_tree().change_scene_to_file(Global.REFS.Start)
