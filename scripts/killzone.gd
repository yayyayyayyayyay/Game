extends Area2D

func _on_body_entered(body: Node2D) -> void:

	if not body.is_in_group("player"):
		return
	if body.dead:  # skip if already dead
		return
	if body.has_method("die"):
		body.call_deferred("die")
 
