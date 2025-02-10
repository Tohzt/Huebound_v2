class_name CellClass
extends Node2D
@export_category("Shaders")
@export var sh_greyscale: ShaderMaterial
@export var sh_highlight: ShaderMaterial
@onready var block_sprite: Sprite2D = $BlockSprite

@onready var light_occluder_2d:LightOccluder2D = $LightOccluder2D
@onready var cell: StaticBody2D = $StaticBody2D
var pos_in = position.y
var pos_out = position.y + 60
@onready var pos = position.y
var rumble_timer = 0.0
var is_rumbling = false

var hue: HueClass
var color: Color
var color_shaded: Color
var cell_solid = false
var cell_grid_pos: Vector2
var slide_speed = randf_range(5.0, 15.0)


func _ready():
	block_sprite.material = sh_greyscale
	light_occluder_2d.sdf_collision = false
	light_occluder_2d.hide()
	pos = position.y
	pos_in = pos
	pos_out = pos + 60
	hue = get_tree().get_first_node_in_group("Hue")
	color = Global.color_palette.pick_random()
	color_shaded = color
	block_sprite.modulate = color_shaded.darkened(0.5)
	var cell_x_pos = floor(global_position.x / Settings.cell_size)
	var cell_y_pos = abs(floor((global_position.y + 60) / Settings.cell_size)+1)
	cell_grid_pos = Vector2(cell_x_pos, cell_y_pos)
	update_solid()
	# Default greyout effect


func _process(delta):
	block_sprite.z_index = int(cell_grid_pos.y+1)
	if !cell_solid:
		block_sprite.z_index = int(cell_grid_pos.y-1)
		
		## Highlight next active color
		# TODO: Shader?
		if hue.cur_color == color.darkened(0.0):
			#block_sprite.material = sh_highlight
			#await get_tree().create_timer(.5).timeout
			#block_sprite.material = sh_greyscale
			#block_sprite.modulate = color_shaded.darkened(0.25)
			pass
		else:
			block_sprite.modulate = color_shaded.darkened(0.5)
	
	# Add rumble effect and increase greyout when Hue is falling to death
	if !hue.alive and !hue.death_splat:
		is_rumbling = true
		rumble_timer += delta * 10
		if rumble_timer >= 1.0:
			rumble_timer = 0.0
			pos = pos_in if randf() > 0.75 else pos_in + (pos_out - pos_in) / 2
			
			# Gradually increase greyout effect (0.0 to 1.0)
			if block_sprite.material != sh_greyscale: return
			var current_greyout = block_sprite.material.get_shader_parameter("greyout")
			block_sprite.material.set_shader_parameter("greyout", lerp(current_greyout, 1.0, delta/20))
	else:
		is_rumbling = false
		if !cell_solid:
			pos = pos_in
		
		if hue.alive:
			if cell_solid: 
				light_occluder_2d.sdf_collision = true
				light_occluder_2d.show()
			else: 
				light_occluder_2d.sdf_collision = false
				light_occluder_2d.hide()
			
			if block_sprite.material != sh_greyscale: return
			var current_greyout = block_sprite.material.get_shader_parameter("greyout")
			block_sprite.material.set_shader_parameter("greyout", lerp(current_greyout, 0.0, delta/200))
		
	
	# Faster lerp speed during rumble
	var current_speed = slide_speed * (0.5 if is_rumbling else 1.0)
	position.y = lerp(position.y, pos, delta * current_speed)
	
	cell.set_collision_layer_value(1, cell_solid)

func update_solid():
	if Global.active_color.has(color.darkened(0.0)):
		block_sprite.modulate = color_shaded.darkened(0.0)
		cell_solid = true
		pos = pos_out
		if cell_grid_pos == hue.hue_grid_pos:
			hue.death_to_heuy()
	else:
		block_sprite.modulate = color_shaded.darkened(0.5)
		cell_solid = false
		pos = pos_in
