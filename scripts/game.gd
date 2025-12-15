extends Node2D

@onready var player1 = $Player
@onready var player2 = $Player2

func _process(_delta):
	# Player 2 rewinds Player 1 (↓)
	player1.set_rewinding(
		Input.is_action_pressed("p2_rewind_other")
	)

	# Player 1 rewinds Player 2 (S)
	player2.set_rewinding(
		Input.is_action_pressed("p1_rewind_other")
	)
