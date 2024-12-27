extends RigidBody3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var collision_shape_3d = $CollisionShape3D

var color: Color
var active = false
var original_position: Vector3
var target_position: Vector3
const SLIDE_DISTANCE = 1.0
var LERP_SPEED = randf_range(1.0,4.0) 
@export var emission_energy = 0.15
var unigue_glow
func _ready():
	var glow_material = mesh_instance_3d.get_surface_override_material(0)
	unigue_glow = glow_material.duplicate()
	color = Global.colors_3d.pick_random()
	unigue_glow.albedo_color = color
	unigue_glow.emission = color
	unigue_glow.emission_energy = emission_energy
	mesh_instance_3d.set_surface_override_material(0, unigue_glow)
	
	original_position = position
	target_position = original_position

func _process(delta):
	collision_shape_3d.global_position.z = 0
	target_position = original_position + (Vector3(0, 0, SLIDE_DISTANCE) if active else Vector3.ZERO)
	
	position = position.lerp(target_position, LERP_SPEED * delta)
	
	# Get the material and adjust brightness and emission based on active state
	var material = mesh_instance_3d.get_surface_override_material(0)
	if active:
		material.albedo_color = color
		unigue_glow.emission_enabled = true
		collision_layer = 2  # Enable collisions on layer 2
	else:
		material.albedo_color = color.darkened(0.3)
		unigue_glow.emission_enabled = false
		collision_layer = 0  # Disable collisions
