extends AnimatableBody2D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play_backwards("move")

func _on_button_pressed_changed(pressed: Variant) -> void:
	if pressed:
		anim.play("move")
	else:
		anim.play_backwards("move")
