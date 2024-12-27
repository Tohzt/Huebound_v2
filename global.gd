class_name GlobalClass
extends Node

const REFS ={
	"Start": "res://Main Menu/main_menu.tscn",
	"Game": "res://Game/Game.tscn",
	"Hue": preload("res://Huey/hue.tscn"),
	"Cell": preload("res://Cell/cell.tscn"),
	"Item": preload("res://Item/item.tscn"),
	"Block": preload("res://3D Block/Block.tscn")
	}
	
var screen_width = DisplayServer.window_get_size().x
var screen_height = DisplayServer.window_get_size().y
var view_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var view_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var palette_color: Array[int] = [7, 8, 9] 
var active_color: Array[int] = [] 

var height = 0
var height_max = 0

var chunks = 0
var add_chunk = false


var colors_3d = [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(1, 1, 0), Color(0, 1, 1)]
