class_name GlobalClass
extends Node
const REFS ={
	"Start": "res://Main Menu/main_menu.tscn",
	"Game": "res://Game/Game.tscn",
	"Win_Lose": "res://Win_Lose/Win_Lose.tscn",
	"Leaderboard": "res://addons/silent_wolf/Scores/Leaderboard.tscn",
	"Huey": preload("res://Huey/hue.tscn"),
	"Cell": preload("res://Cell/cell.tscn"),
	"Item": preload("res://Item/item.tscn"),
	"UI_Cell": preload("res://Main Menu/UI_Cell/ui_cell.tscn")
	}
	
var screen_width = DisplayServer.window_get_size().x
var screen_height = DisplayServer.window_get_size().y
var view_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var view_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var palette_default: Array[Color] = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW] 
var palette_1: Array[Color] = [Color("#4b91e2"), Color("#50e2c3"), Color("#f5a524"), Color("#cf021a")]#, Color("#3cb062")] 
var palette_2: Array[Color] = [Color("#00b3aa"), Color("#ff6e61"), Color("#ff9b3d"), Color("#ffff49")]#, Color("#976cfb")] 
var palette_3: Array[Color] = [Color("#f9c54e"), Color("#91be6f"), Color("#56778f"), Color("#f94346")]#, Color("#f187b3")] 
var palette_4: Array[Color] = [Color("#ffd900"), Color("#abff2e"), Color("#00bfff"), Color("#ff6bb5")]#, Color("#707df8")] 
var palette_5: Array[Color] = [Color(randf(), randf(), randf(), 1), Color(randf(), randf(), randf(), 1), Color(randf(), randf(), randf(), 1), Color(randf(), randf(), randf(), 1)] 
var palette_grey: Array[Color] = [Color("#4c4c4c"),Color("#848484"),Color("#dddddd"),Color("#bcbcbc")]
var color_palette: Array[Color] = palette_default
var active_color: Array[Color] = [] 

var height = 0
var height_max = 20
var personal_best = 0
var top_10 = INF

var add_chunk = false

## Leaderboard
var player_name: String = "Huey"
var player_list = []
var score = 0
var new_record = false

func _ready():
	#active_color = [color_palette.pick_random()]
	
	var file = FileAccess.open("res://apiKey.env", FileAccess.READ)
	var apiKey = file.get_as_text()
	
	SilentWolf.configure({
		"api_key": apiKey,
		"game_id": "HueBound",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": REFS.Start
	})

	# Fetch leaderboard scores before building the grid
	await _fetch_leaderboard()

func _fetch_leaderboard():
	# Get all scores from SilentWolf
	await get_tree().create_timer(0.1).timeout  # Give time for scene tree to initialize
	var sw_result = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	if sw_result.scores:
		# Find the highest score from the leaderboard
		var highest_score = 0
		for score_data in sw_result.scores:
			if score_data.score < top_10:
				top_10 = score_data.score
			if score_data.score > highest_score:
				highest_score = score_data.score
		# Update the global height_max with the highest score
		height_max = max(highest_score, height_max)

func _process(_delta):
	pass

# TODO: Test in process
func _physics_process(_delta):
	leaderboard()

func leaderboard():
	for _score in Global.score:
		Global.player_list.append(Global.player_name )
