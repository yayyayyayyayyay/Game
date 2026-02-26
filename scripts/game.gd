extends Node2D

var player1: Node = null
var player2: Node = null

@onready var level_root: Node2D = $LevelRoot

func _ready():
	refresh_players()

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
