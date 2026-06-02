extends Node

var current_level_index := 0

var levels := [
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

var unlocked_levels := 1


func get_current_level_path():
	return levels[current_level_index]


func complete_level():
	if current_level_index + 1 >= unlocked_levels:
		unlocked_levels += 1
