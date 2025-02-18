extends Node2D

@onready var Hue = $Hue

var num_rows = 40
var num_cols = 6
var chunk_shift = 1
var rows_to_chunk = 10

func _ready():
	Global.new_record = false
	Global.add_chunk = true
	_build_grid()

func _build_grid():
	# TODO Spawn item into block. Easier to hide when block is active
	if !Global.add_chunk: return
	var yy = num_rows
	var xx = num_cols
	for y in yy:
		for x in xx:
			#Spawn Block
			var cell = Global.REFS.Cell.instantiate()
			var x_pos =  x*Settings.cell_size + Settings.cell_offset
			var y_pos = -y*Settings.cell_size - Settings.cell_base#(Settings.cell_size*2.5)
			cell.position = Vector2(x_pos, y_pos)
			get_node("Cell Container").add_child(cell)
			if y > 10:
				_add_item(cell)
			
	Global.add_chunk = false

func _process(_dela):
	# Recycle Cells to Top of Stack
	if Global.height > num_rows - 10:
		var cells = get_tree().get_nodes_in_group("Cell")
		for cell: CellClass in cells:
			if cell.cell_grid_pos.y >= chunk_shift \
			and cell.cell_grid_pos.y < chunk_shift+rows_to_chunk:
				cell.position.y = cell.pos_in
				cell.position.y -= 40*Settings.cell_size
				cell._ready()
				cell.update_solid()
				_add_item(cell)
		
		num_rows += rows_to_chunk
		chunk_shift += rows_to_chunk

func _add_item(cell):
	if randi() % 100 > Settings.item_frequency: return
	var item = Global.REFS.Item.instantiate()
	var cell_offset = Vector2(60, -60)
	item.position = cell.position + cell_offset
	get_node("Item Container").add_child(item)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file(Global.REFS.Start)


func _on_btn_exit_pressed():
	get_tree().change_scene_to_file(Global.REFS.Start)
