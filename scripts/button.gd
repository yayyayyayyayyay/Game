extends Area2D

signal pressed_changed(pressed)

@onready var sprite = $AnimatedSprite2D
@export var targets: Array[NodePath]
@export var button_color := Color.WHITE
	

var press_count = 0
var is_pressed = false

func _ready():
	sprite.modulate = button_color
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("button_pressers"):
		press_count += 1
		update_button()

func _on_body_exited(body):
	if body.is_in_group("button_pressers"):
		press_count -= 1
		update_button()

func update_button():
	var new_pressed = press_count > 0

	if new_pressed != is_pressed:
		is_pressed = new_pressed

		if is_pressed:
			sprite.play("pressed")
		else:
			sprite.play("released")

		pressed_changed.emit(is_pressed)
