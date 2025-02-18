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
@onready var backfill: Sprite2D = $backfill
@onready var fill: Sprite2D = $fill
@onready var border: AnimatedSprite2D = $border
@onready var rc_right: RayCast2D = $RC_Right
@onready var rc_left: RayCast2D = $RC_Left
@onready var InputManager = $"../InputManager"  # Adjust path as needed
@onready var camera: Camera2D = get_parent().get_node("Camera2D")

## Character State
var power: String = ""
var jump: int = 0
var jump_max: int = 2
var cur_color: Color
var climbing: bool = true
var alive = true
var dying = false
var color_swapped: bool = true
var death_pos: Vector2

## Power Ups
var wall_cling: bool = false
var shuffle_grid = false
var random_swap = false

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

# Touch visualization
var touch_positions: Array[Vector2] = []
const TOUCH_CIRCLE_RADIUS = 20
const TOUCH_CIRCLE_COLOR = Color(1, 1, 1, 0.5)  # Semi-transparent white

var jump_direction = Vector2.ZERO
const JUMP_HORIZONTAL_BOOST = 0.75  # Reduced from 1.5

func _ready() -> void:
	border.play("Idle")
	cur_color = Color.WHITE#Global.active_color[0]
	fill.modulate = cur_color
	InputManager.interaction_moved.connect(_on_interaction_moved)
	InputManager.interaction_ended.connect(_on_interaction_ended)
	InputManager.interaction_swiped.connect(_on_interaction_swiped)

func _on_interaction_moved(movement: Vector2):
	# Clear jump direction when player starts moving again
	if InputManager.is_touching:
		jump_direction = Vector2.ZERO
	
	# Handle horizontal movement
	if abs(movement.x) <= 1.0:
		move_lr = movement.x

func _on_interaction_ended(_position, was_tap: bool = false):
	move_lr = 0.0
	if was_tap:
		mv_down = true  # Trigger color swap on tap

func _on_interaction_swiped(direction: Vector2):
	if direction.y < 0 and jump < jump_max:
		# Reduce horizontal influence
		var enhanced_direction = direction
		enhanced_direction.x *= 0.75  # Reduced from 1.5
		jump_direction = enhanced_direction
		mv_jump = true

func _draw():
	# Draw circles at touch positions
	for pos in touch_positions:
		draw_circle(pos, TOUCH_CIRCLE_RADIUS, TOUCH_CIRCLE_COLOR)

func set_active_color(colors: Array[Color]) -> void:
	Global.active_color.clear()
	Global.active_color = colors

func _process(_delta: float) -> void:
	if !alive: return
	if velocity.length() > 100:
		var v_len_max = 500
		var v_len = max(velocity.length(), v_len_max)
		border.play("Move")
		border.speed_scale = lerp (1, 3, v_len/v_len_max)
	else:
		border.play("Idle")
	backfill.z_index = int(hue_grid_pos.y+1)
	fill.z_index = int(hue_grid_pos.y+1)
	border.z_index = int(hue_grid_pos.y+1)
	#label.text = "[" + str(border.z_index) + "]"

var death_splat = false
func _physics_process(delta):
	if !alive: 
		var _lr = Input.get_axis("ui_left", "ui_right")
		velocity.x = _lr*SPEED/2
		velocity += get_gravity() * delta
		if !death_splat: 
			move_and_slide()
		if dying:
			border.global_position.x = position.x
			border.global_position.y = position.y-40

		
		if is_on_floor():
			if !death_splat:
				death_splat = true
				border.global_position = fill.global_position
				fill.hide()
				backfill.hide()
				border.speed_scale = 1.0
				border.scale = Vector2(2.0,2.0)
				border.modulate = cur_color
				border.play("Pop Inner")
				
				await get_tree().create_timer(1.0).timeout
				Global.active_color.clear()
				#get_tree().change_scene_to_file(Global.REFS.Start)
				TransitionHandler.fade_out(get_tree().current_scene, Global.REFS.Win_Lose, 0.1, Color.BLACK)
			
		#position.y = lerp(position.y, death_pos.y + 60, delta*10)
		#camera.zoom = lerp(camera.zoom, Vector2(2,2), delta*5)
		camera.position.y = lerp(camera.position.y, position.y, delta*10)
		
		return
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


func _update_grid_pos():
	var hue_x_pos = floor((origin.global_position.x - Settings.cell_offset) / Settings.cell_size)
	var hue_y_pos = abs(floor((origin.global_position.y + Settings.cell_offset) / Settings.cell_size)+1)
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
			if shuffle_grid:
				cell.color = Global.color_palette.pick_random()
				cell.color_shaded = cell.color
				cell.block_sprite.modulate = cell.color
				if !cell.cell_solid:
					cell.block_sprite.modulate = cell.color.darkened(0.25)
				color_swapped = true
			elif cell.cell_grid_pos == hue_grid_pos:
				cur_color = cell.color  # Immediately update the active color
				if random_swap :
					cur_color = Global.color_palette.pick_random()
				else:
					cell.color = _col
					cell.color_shaded = _col
					cell.block_sprite.modulate = _col.darkened(0.25)
				fill.start_animation(cur_color)  # Pass the new color to the animation
				color_swapped = true


func _climbing():
	if climbing: 
		Global.height = int(abs(global_position.y) / Settings.cell_size)
		Global.personal_best = max(Global.personal_best, Global.height)
			
		if Global.height > Global.top_10:
			Global.height_max = Global.height
			Global.new_record = true
	elif int(abs(global_position.y) / Settings.cell_size) <= 1:
		climbing = true

func _friction(delta):
	# Only apply friction if we're not getting touch input
	if !InputManager.is_touching:
		if input_move.x != 0:
			move_lr = lerp(move_lr, input_move.x, delta*10)
		elif jump == 0:
			move_lr = 0.0
		else:
			move_lr = lerp(move_lr, 0.0, delta*10)

func _power_ups():
	jump_max = 2
	wall_cling = false
	shuffle_grid = false
	random_swap = false
	match power:
		"triple_jump":
			jump_max = 3
		"wall_cling":
			wall_cling = true
		"shuffle":
			shuffle_grid = true
		"random_swap":
			random_swap = true

func _jump_and_toggle_cells():
	if mv_jump and jump < jump_max:
		mv_jump = false
		if color_swapped:
			color_swapped = false
			set_active_color([cur_color])
			update_cells()
		jump += 1
		
		# Apply both vertical and horizontal velocity
		velocity.y = JUMP_VELOCITY
		velocity.x = SPEED * jump_direction.x * JUMP_HORIZONTAL_BOOST

func _listen_for_input(delta):
	_mobile_input(delta)
	_keyboard_input(delta)

func _keyboard_input(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if jump < jump_max:
			mv_jump = true
	
	if Input.is_action_just_pressed("ui_down"):
		mv_down = true
		
	var input_dir = Input.get_axis("ui_left", "ui_right")
	if input_dir != 0:  # Only update move_lr if there's keyboard input
		move_lr = lerp(move_lr, input_dir, delta*60)

func _mobile_input(delta):
	# Only update move_lr if there's mobile input and no keyboard input
	if input_move.x != 0 and Input.get_axis("ui_left", "ui_right") == 0:
		move_lr = lerp(move_lr, input_move.x, delta*10)
	
	if input_tap:
		input_tap = false
		if abs(move_lr) < 0.5:
			mv_down = true
	
	if input_swipe.length() > 0:
		var swipe_dir = rad_to_deg(input_swipe.angle())
		if swipe_dir < -30 and swipe_dir > -150:
			mv_jump = true
		input_swipe = Vector2.ZERO

func _respond_to_input():
	# Apply velocity from either touch or keyboard input
	if move_lr != 0:
		velocity.x = move_lr * SPEED
	elif jump_direction != Vector2.ZERO:
		# Only maintain jump direction if we're moving upward or at peak of jump
		if velocity.y <= 0:
			velocity.x = jump_direction.x * SPEED * JUMP_HORIZONTAL_BOOST
		else:
			jump_direction = Vector2.ZERO  # Clear direction when falling
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var col = rc_right.get_collider() or rc_left.get_collider()
	if floor(abs(move_lr)) == 0: col = false
	if wall_cling and col:
		jump = max(1, jump_max-1)
		velocity.y = min(velocity.y, 0)
	
	move_and_slide()

func _death_under_camera():
	var camera_bottom = camera.global_position.y + get_viewport_rect().size.y/2
	if global_position.y > camera_bottom + 50:  # Add small buffer of 100 pixels
		death_to_heuy()



func update_cells():
	var cells = get_tree().get_nodes_in_group("Cell")
	for cell: CellClass in cells:
		# TODO: Call function like item does
		cell.update_solid()
	
	var items = get_tree().get_nodes_in_group("Item")
	for item: ItemClass in items:
		item.check_visible()

func _on_joystick_move_vector(move: Vector2, tap: bool, swipe: Vector2):
	input_move = move
	input_tap = tap
	input_swipe = swipe

func death_to_heuy():
	if alive:
		$PointLight2D.enabled = false
		$PointLight2D.hide()
		death_pos = position
		if Global.new_record:
			Global.new_record = true
	alive = false
	dying = true
	
	backfill.z_index = 4000
	fill.z_index = 4000
	border.z_index = 4000
	#Engine.time_scale = 0.25
	#await get_tree().create_timer(.1).timeout
	#get_tree().change_scene_to_file(Global.REFS.Win_Lose)
	var items = get_tree().get_nodes_in_group("Item")
	for item in items: item.queue_free()
	Global.active_color.clear()
	var cells = get_tree().get_nodes_in_group("Cell")
	for cell: CellClass in cells:
		cell.modulate = cell.color.darkened(0.25)
		cell.cell_solid = false
		cell.update_solid()
	border.play("Pop")
	dying = false
	border.scale = Vector2(0.75, 0.75)
	#Engine.time_scale = 1.0
