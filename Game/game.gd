extends Node2D

@onready var Hue = $Hue

const Z_INDEX_RESET_THRESHOLD = 10000  # Adjust as needed
var base_z_index = 0

func _ready():
	Global.new_record = false
	Global.add_chunk = true
	_build_grid()

func _build_grid():
	# TODO Spawn item into block. Easier to hide when block is active
	if !Global.add_chunk: return
	var yy = 40
	var xx = 5
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
	if Global.height > 40 - 6:
		var cells = get_tree().get_nodes_in_group("Cell")
		var num_rows = 40
		var chunk_shift = 1
		
		# Regular recycling logic
		for cell: CellClass in cells:
			if cell.cell_grid_pos.y >= chunk_shift and cell.cell_grid_pos.y < chunk_shift + 10:
				var row_offset = cell.cell_grid_pos.y - chunk_shift
				cell.position.y = -(num_rows + 1 - (9 - row_offset)) * Settings.cell_size
				cell._ready()
				cell.update_solid()
		chunk_shift += 10


func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file(Global.REFS.Start)


func _on_btn_exit_pressed():
	get_tree().change_scene_to_file(Global.REFS.Start)
