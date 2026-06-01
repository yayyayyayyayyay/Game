extends Control

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

var levels = [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn",
	"res://scenes/level_4.tscn",
	"res://scenes/level_5.tscn",
	"res://scenes/level_6.tscn",
	"res://scenes/level_7.tscn",
	"res://scenes/level_8.tscn",
	"res://scenes/level_9.tscn",
	"res://scenes/level_10.tscn",
	"res://scenes/level_11.tscn",
	"res://scenes/level_12.tscn"
]

var button_scene = preload("res://scenes/level_button.tscn")

func _ready():
	create_level_buttons()

func create_level_buttons():
	for i in range(levels.size()):
		var btn = button_scene.instantiate()
		
		btn.level_index = i
		btn.level_scene = levels[i]

		btn.text = str(i + 1)

		btn.pressed.connect(_on_level_pressed.bind(i))
		btn.disabled = i >= GameManager.unlocked_levels
		grid.add_child(btn)

func _on_level_pressed(level_index):
	GameManager.current_level_index = level_index

	get_tree().change_scene_to_file(
		"res://scenes/game.tscn"
	)
