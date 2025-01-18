class_name HueClass
extends CharacterBody2D

## Movement Constants
const SPEED: float = 350.0
const JUMP_VELOCITY: float = -500.0

## Node References
@onready var label: Label = $Label
@onready var start_pos: Vector2 = position
@onready var width: float = 80.0 * scale.x
@onready var origin: Area2D = $Origin
@onready var fill: Sprite2D = $fill
@onready var border: Sprite2D = $border
@onready var rc_right: RayCast2D = $RC_Right
@onready var rc_left: RayCast2D = $RC_Left

## Character State
var power: String = ""
var jump: int = 0
var jump_max: int = 2
var wall_cling: bool = false
var cur_color: Color
var climbing: bool = true
var alive = true
var color_swapped: bool = true

## Movement State
var active: bool  = true
var mv_jump: bool = false
var move_lr: float = 0.0
var mv_down: bool = false
var hue_grid_pos: Vector2

## Input State
var input_move: Vector2
var input_tap: bool
var input_swipe: Vector2

func _ready() -> void:
	cur_color = Global.active_color[0]
	fill.modulate = cur_color

func set_active_color(colors: Array[Color]) -> void:
	Global.active_color.clear()
	Global.active_color = colors

func _process(_delta: float) -> void:
	border.z_index = abs(position.y) / 10 + 15
	fill.z_index = abs(position.y) / 10 + 15
	label.text = "[" + str(border.z_index) + "]"

func _update_grid_pos():
	var hue_x_pos = floor((origin.global_position.x - Settings.cell_offset) / Settings.cell_size)
	var hue_y_pos = abs(floor((origin.global_position.y + Settings.cell_offset) / Settings.cell_size))
	hue_grid_pos = Vector2(hue_x_pos, hue_y_pos)

func _gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump = 0

func _limit_borders():
	# Prevent movement outside of game-space
	if position.x <= width/2.0:
		position.x = width/2.0
	if position.x >= Global.view_width - width/2.0:
		position.x = Global.view_width - width/2.0
	if position.y >= -width/2.0:
		velocity.y = 0
		position.y = -width/2.0
		jump = 0

func _swap_colors():
	if mv_down:
		mv_down = false
		var _col: Color = cur_color
		var cells = get_tree().get_nodes_in_group("Cell")
		for cell: CellClass in cells:
			if cell.cell_grid_pos == hue_grid_pos:
				cur_color = cell.color
				cell.color = _col
				cell.color_shaded = _col
				cell.block_sprite.modulate = _col.darkened(0.25)
				fill.modulate = cur_color
				color_swapped = true
				break

func _climbing():
	if climbing: 
		Global.height = int(abs(global_position.y) / Settings.cell_size)
		if Global.height > Global.height_max:
			Global.height_max = Global.height
			Global.new_record = true
	elif int(abs(global_position.y) / Settings.cell_size) <= 1:
		climbing = true

func _friction(delta):
	if input_move.x != 0:
		move_lr = lerp(move_lr, input_move.x, delta*10)
	elif jump == 0:
		move_lr = 0.0
	else:
		move_lr = lerp(move_lr, 0.0, delta*10)
	
	if input_swipe.y < -0.5:
		mv_jump = true

func _power_ups():
	jump_max = 2
	wall_cling = false
	match power:
		"triple_jump":
			jump_max = 3
		
		"wall_cling":
			wall_cling = true

func _jump_and_toggle_cells():
	if mv_jump and jump < jump_max:
		mv_jump = false
		if color_swapped:
			color_swapped = false
			set_active_color([cur_color])
			update_cells()
		jump += 1
		velocity.y = JUMP_VELOCITY

func _listen_for_input(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if jump < jump_max:
			mv_jump = true
	
	if Input.is_action_just_pressed("ui_down"):
		mv_down = true
		
	var input_dir = Input.get_axis("ui_left", "ui_right")
	if input_dir == 1: move_lr = lerp(move_lr, 1.0, delta*60)
	elif input_dir == -1: move_lr = lerp(move_lr, -1.0, delta*60)

func _respond_to_input():
	if move_lr:
		velocity.x = move_lr * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var col = rc_right.get_collider() or rc_left.get_collider()
	if floor(abs(move_lr)) == 0: col = false
	if wall_cling and col:
		jump = max(1, jump_max-1)
		velocity.y = min(velocity.y, 0)
	
	move_and_slide()

func _death_under_camera():
	var camera = get_parent().get_node("Camera2D")
	var camera_bottom = camera.global_position.y + get_viewport_rect().size.y/2
	if global_position.y > camera_bottom + 50:  # Add small buffer of 100 pixels
		death_to_heuy()
	
func _physics_process(delta):
	_update_grid_pos()
	_gravity(delta)
	_limit_borders()
	_swap_colors()
	_climbing()
	_friction(delta)
	_power_ups()
	_jump_and_toggle_cells()
	if active: _listen_for_input(delta)
	_respond_to_input()
	_death_under_camera()
	if !alive: 
		get_tree().change_scene_to_file(Global.REFS.Win_Lose)

	
	#if input_tap:
		#input_tap = false
		#if abs(move_lr) < 0.5:
			#mv_down = true
#
	#if input_swipe.length() > 0:
		#input_swipe = Vector2.ZERO
		#var swipe_dir = rad_to_deg(input_swipe.angle())
		#if swipe_dir < -30 and swipe_dir > -150:
			#mv_jump = true

func update_cells():
	var cells = get_tree().get_nodes_in_group("Cell")
	for cell: CellClass in cells:
		# TODO: Call function like item does
		cell.update_solid()
	
	var items = get_tree().get_nodes_in_group("Item")
	for item: ItemClass in items:
		item.check_visible()

# This function will be called whenever the joystick emits its signal
func _on_joystick_move_vector(move: Vector2, tap: bool, swipe: Vector2):
	input_move = move
	input_tap = tap
	input_swipe = swipe

func death_to_heuy():
	alive = false
	print_debug("DEAD")
	position = start_pos
	if Global.new_record:
		Global.new_record = true
		#active = false
		#get_parent().lb_input_name.show()
