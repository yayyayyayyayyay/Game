extends Node2D


var player1: Node = null
var player2: Node = null

@onready var level_root: Node2D = $LevelRoot
@onready var pause_menu = $PauseMenu

func _ready():
	await SceneTransition.fade_from_black()

	load_level(
		GameManager.get_current_level_path()
	)

	refresh_players()


func load_next_level():
	GameManager.current_level_index += 1

	if GameManager.current_level_index >= GameManager.levels.size():
		print("No more levels!")
		return

	get_tree().paused = true

	await SceneTransition.fade_to_black()

	load_level(GameManager.get_current_level_path())
	GameManager.complete_level()
	
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
	if Input.is_action_just_pressed("restart_level") and not get_tree().paused:
		restart_level()
		return
	if player1 == null or player2 == null:
		refresh_players()

		if player1 == null or player2 == null:
			return

	# Player 2 rewinds Player 1
	player1.set_rewinding(
		Input.is_action_pressed("p2_rewind_other")
	)

	# Player 1 rewinds Player 2
	player2.set_rewinding(
		Input.is_action_pressed("p1_rewind_other")
	)


func load_level(scene_path: String):
	# Clear old level
	for child in level_root.get_children():
		child.queue_free()

	# Load new level
	var packed := load(scene_path) as PackedScene
	var level := packed.instantiate()

	level_root.add_child(level)

	# Wait one frame so nodes enter tree properly
	await get_tree().process_frame

	refresh_players()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_menu.close()
		else:
			pause_menu.open()
			
func restart_level():
	get_tree().paused = true

	await SceneTransition.fade_to_black()

	load_level(
		GameManager.get_current_level_path()
	)

	await SceneTransition.fade_from_black()

	get_tree().paused = false
