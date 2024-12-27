class_name ItemClass
extends Node2D

var power: String = ""

func _ready():
	power = ["triple_jump","wall_cling"].pick_random()
	if power == "wall_cling":
		$Sprite2D.frame = 1

func _on_area_2d_body_entered(Hue): 
	if !Hue: return
	if Hue.is_in_group("Hue"):
		Hue.power = power
		queue_free()
