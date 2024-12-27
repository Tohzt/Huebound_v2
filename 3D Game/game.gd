extends Node3D
@onready var camera_3d = $Camera3D
@onready var cam_start_pos = camera_3d.global_position
@onready var huey = $Huey

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if huey.global_position.y > cam_start_pos.y:
		camera_3d.position.y = lerp(camera_3d.position.y, huey.position.y, delta * 5)
	else: 
		camera_3d.position.y = lerp(camera_3d.position.y, cam_start_pos.y, delta * 5)
	
	if Input.is_action_just_pressed("ui_enter"):  # Space bar
		var selected_color = Global.colors_3d.pick_random()
		_activate_blocks_by_color(selected_color)

func _activate_blocks_by_color(target_color: Color):
	# Get all blocks in the scene
	var blocks = get_tree().get_nodes_in_group("Block")
	
	# Deactivate all blocks first
	for block in blocks:
		block.active = false
	
	# Activate only blocks matching the target color
	for block in blocks:
		if block.color == target_color:
			block.active = true
	
