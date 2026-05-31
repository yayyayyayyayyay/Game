extends AnimatableBody2D

@onready var anim = $AnimationPlayer


func _on_button_pressed_changed(pressed: Variant) -> void:
	if pressed:
		anim.play("move")
	else:
		anim.play_backwards("move")
