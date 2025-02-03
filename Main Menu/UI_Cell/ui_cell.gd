extends UI_CELL_CLASS


func _ready():
	super._ready()
	pos_in = pos_out
	pos_out += push_dist
	pos += push_dist
	
	color = Global.palette_grey.pick_random()
	color_shaded = color
	modulate = color_shaded.darkened(0.5)

func _process(delta):
	#if cell_solid:
		#Global.active_color.clear()
		#Global.active_color.append(color)
	#
	#if Global.active_color.has(color):
		#cell_solid = true
	#else:
		#cell_solid = false
	
	super._process(delta)
	cell_solid = false
