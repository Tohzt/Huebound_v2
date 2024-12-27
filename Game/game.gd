extends Node2D

@onready var Hue = $Hue

var num_rows = 100
var num_cols = 5

func _ready():
	Global.add_chunk = true
	_build_grid(Global.chunks)


func _build_grid(chunk):
	if !Global.add_chunk: return
	var yy = num_rows
	var xx = num_cols
	#var cur_cel = 0
	var _freq = Settings.item_frequency
	for y in yy:
		for x in xx:
			#Spawn Block
			var cell = Global.REFS.Cell.instantiate()
			cell.color_index = Global.palette_color.pick_random()
			
			var x_pos =  x*Settings.cell_size+Settings.cell_size/2.0
			var chunk_offset = chunk * num_rows * Settings.cell_size
			var y_pos = -y*Settings.cell_size-Settings.cell_size/2.0 - chunk_offset
			cell.position = Vector2(x_pos, y_pos)
			get_node("Cell Container").add_child(cell)
			
			if y*(Global.chunks+1) > 10 and randi() % 100 < _freq:
				var item = Global.REFS.Item.instantiate()
				item.position = cell.position
				get_node("Item Container").add_child(item)
			
	Global.add_chunk = false
	Global.chunks += 1

func _process(_delta):
	if Global.height > Global.chunks*num_rows - 6:
		Global.add_chunk = true
		_build_grid(Global.chunks)


func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.active_color.clear()
		get_tree().change_scene_to_file(Global.REFS.Start)



func _on_btn_exit_pressed():
	Global.active_color.clear()
	get_tree().change_scene_to_file(Global.REFS.Start)
