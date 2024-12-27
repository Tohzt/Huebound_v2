extends CharacterBody3D
class_name  HueClass_3D

@onready var start_pos = position

const SPEED = 3.0
const JUMP_VELOCITY = 5.0

var direction: int
var power: String = ""
var jump = 0
var jump_max = 1
var jump_mod = 0
var wall_cling = false

var hov_color: CellClass
var cur_color = 0  

var climbing = false
var mv_jump = false
var move_lr = 0.0
var mv_down = false
var hue_grid_pos: Vector2

var input_move: Vector2
var input_tap: bool
var input_swipe: Vector2

func _ready():
	pass

func set_active_color(colors: Array[int]):
	Global.active_color.clear()
	Global.active_color = colors

func _process(delta):
	print(global_position)
func _physics_process(delta):
	var hue_x_pos = floor(global_position.x / Settings.cell_size)
	var hue_y_pos = abs(floor(global_position.y / Settings.cell_size)+1)
	hue_grid_pos = Vector2(hue_x_pos, hue_y_pos)
	
	if mv_down:
		mv_down = false
		pass
		#var _col = cur_color
		#cur_color = hov_color.color_index
		#hov_color.color_index = _col
		#hov_color.sprite.frame = _col + 10
		#hov_color.cell_solid = false
	
	if climbing: 
		Global.height = int(abs(global_position.y) / Settings.cell_size)
		Global.height_max = max(Global.height, Global.height_max)

	if input_move.x != 0:
		move_lr = lerp(move_lr, input_move.x, delta*10)
	elif jump == 0:
		move_lr = 0.0
	else:
		move_lr = lerp(move_lr, 0.0, delta*10)
	
	if input_swipe.y < -0.5:
		mv_jump = true
	
	if input_tap:
		input_tap = false
		if abs(move_lr) < 0.5:
			mv_down = true

	if input_swipe.length() > 0:
		input_swipe = Vector2.ZERO
		var swipe_dir = rad_to_deg(input_swipe.angle())
		if swipe_dir < -30 and swipe_dir > -150:
			mv_jump = true
			
	jump_mod = 0
	wall_cling = false
	match power:
		"triple_jump":
			jump_mod = 1
		
		"wall_cling":
			wall_cling = true
	
	#printt(jump, jump_max, jump_mod)
	if mv_jump and jump < jump_max+jump_mod:
		mv_jump = false
		if jump == 0:
			update_cells()
			set_active_color([cur_color])
		jump += 1
		velocity.y = JUMP_VELOCITY
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		mv_jump = true
	
	if Input.is_action_just_pressed("ui_down"):
		mv_down = true
		
	var input_dir = Input.get_axis("ui_left", "ui_right")
	if input_dir == 1: move_lr = lerp(move_lr, 1.0, delta*60)
	elif input_dir == -1: move_lr = lerp(move_lr, -1.0, delta*60)
	
	if move_lr:
		velocity.x = move_lr * SPEED
		#var col = rc_right.get_collider() or rc_left.get_collider()
		#
		#if wall_cling and col:
			#jump = max(1, jump_max-1)
			#velocity.y = min(velocity.y, 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	if is_on_floor():
		climbing = true
		jump = 0

func update_cells():
	var cells = get_tree().get_nodes_in_group("Cell")
	for cell: CellClass in cells:
		cell.update_solid = true

# This function will be called whenever the joystick emits its signal
func _on_joystick_move_vector(move: Vector2, tap: bool, swipe: Vector2):
	input_move = move
	input_tap = tap
	input_swipe = swipe

func _cell_at_origin(body):
	if body:
		hov_color = body.get_parent()

func death_to_heuy():
	print_debug("DEAD")
	Global.active_color.clear()
	position = start_pos
