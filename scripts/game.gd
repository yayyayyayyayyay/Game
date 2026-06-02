extends Node2D


var player1: Node = null
var player2: Node = null

@onready var level_root: Node2D = $LevelRoot
@onready var pause_menu = $PauseMenu

func _ready():
	await SceneTransition.fade_from_black()

	load_level(GameManager.get_current_level_path())

	refresh_players()


func load_next_level():
	GameManager.current_level_index += 1

	if GameManager.current_level_index >= GameManager.levels.size():
		GameManager.current_level_index = 0

		await SceneTransition.fade_to_black()
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
		return

	GameManager.complete_level()

	get_tree().paused = true
	await SceneTransition.fade_to_black()

	load_level(GameManager.get_current_level_path())

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

	player1.set_rewinding(Input.is_action_pressed("p2_rewind_other"))

	player2.set_rewinding(Input.is_action_pressed("p1_rewind_other"))


func load_level(scene_path: String):
	for child in level_root.get_children():
		child.queue_free()
	
	var packed := load(scene_path) as PackedScene
	var level := packed.instantiate()

	level_root.add_child(level)

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

	load_level(GameManager.get_current_level_path())

	await SceneTransition.fade_from_black()

	get_tree().paused = false
