extends Node2D

var player1: Node = null
var player2: Node = null

var current_level_index := 0

var levels := [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn"
]

@onready var level_root: Node2D = $LevelRoot

func _ready():
	await SceneTransition.fade_from_black()
	refresh_players()
	
func load_next_level():
	current_level_index += 1
	
	if current_level_index >= levels.size():
		print("No more levels!")
		return
	
	get_tree().paused = true
	await SceneTransition.fade_to_black()

	load_level(levels[current_level_index])

	await SceneTransition.fade_from_black()
	get_tree().paused = false

func refresh_players():
	player1 = null
	player2 = null

	for p in get_tree().get_nodes_in_group("player"):
		if "is_player_one" in p and p.is_player_one:
			player1 = p
		else:
			player2 = p

func _process(_delta):
	if player1 == null or player2 == null:
		refresh_players()
		if player1 == null or player2 == null:
			return

	# Player 2 rewinds Player 1
	player1.set_rewinding(Input.is_action_pressed("p2_rewind_other"))

	# Player 1 rewinds Player 2
	player2.set_rewinding(Input.is_action_pressed("p1_rewind_other"))



func load_level(scene_path: String):
	# clear old
	for child in level_root.get_children():
		child.queue_free()

	# instance new
	var packed := load(scene_path) as PackedScene
	var level := packed.instantiate()
	level_root.add_child(level)

	# re-cache references
	await get_tree().process_frame
	refresh_players()
