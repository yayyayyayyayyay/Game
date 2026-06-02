extends CanvasLayer

@onready var root = $Control
@onready var restart_button = $Control/CenterContainer/VBoxContainer/RestartLevelButton

func _ready():
	root.hide()


func open():
	root.show()
	get_tree().paused = true


func close():
	root.hide()
	get_tree().paused = false


func _on_resume_button_pressed():
	close()


func _on_level_select_button_pressed():
	get_tree().paused = false

	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	

func _on_restart_level_button_pressed() -> void:
	close()

	var game = get_tree().get_first_node_in_group("game")

	if game:
		game.restart_level()
