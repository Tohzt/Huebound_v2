extends Node
@onready var Master = get_parent()

func _ready():
	Settings.cell_size = 1.0
	
	Global.add_chunk = true
	_build_grid(Global.chunks)

func _build_grid(chunk):
	if !Global.add_chunk: return
	var yy = Settings.num_rows
	var xx = Settings.num_cols
	
	var _freq = Settings.item_frequency
	for y in yy:
		for x in xx:
			#Spawn Block
			var cell = Global.REFS.Block.instantiate()
			#cell.color_index = Global.palette_color.pick_random()
			var x_pos =  x*Settings.cell_size+Settings.cell_size/2.0
			var chunk_offset = chunk * Settings.num_rows * Settings.cell_size
			var y_pos = y*Settings.cell_size-Settings.cell_size/2.0 - chunk_offset + 1
			cell.position = Vector3(x_pos, y_pos, -0.5)
			add_child(cell)
			
			#if y*(Global.chunks+1) > 10 and randi() % 100 < _freq:
				#var item = Global.REFS.Item.instantiate()
				#item.position = cell.position
				#get_node("Item Container").add_child(item)
			
	Global.add_chunk = false
	Global.chunks += 1
