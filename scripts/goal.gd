extends Area2D

var players_in_goal = []
@onready var game := get_tree().get_first_node_in_group("game")

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not players_in_goal.has(body):
			players_in_goal.append(body)
			check_goal_met()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		players_in_goal.erase(body)

func check_goal_met():
	if players_in_goal.size() == 2:
		for player in players_in_goal:
			player.set_physics_process(false)
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(player, "global_position", global_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.tween_property(player, "scale", Vector2.ZERO, 0.5)
			tween.tween_property(player, "rotation", deg_to_rad(360), 0.5)
		if game:
			game.load_level("res://scenes/level_2.tscn")
