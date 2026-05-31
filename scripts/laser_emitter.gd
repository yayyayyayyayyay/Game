extends Node2D

@onready var ray = $RayCast2D
@onready var line = $Line2D
@export var color := Color.RED
@export var button: NodePath

var active := true

func _ready():
	if button:
		var button_node = get_node(button)
		button_node.pressed_changed.connect(_on_button_pressed_changed)
	line.default_color=color

func _physics_process(_delta):
	if not active:
		return
	var end_point = ray.target_position

	if ray.is_colliding():
		end_point = to_local(ray.get_collision_point())

		var body = ray.get_collider()

		if body.is_in_group("player"):
			if not body.dead:
				body.call_deferred("die")

	line.points = [
		Vector2.ZERO,
		end_point
	]

func _on_button_pressed_changed(pressed: bool):
	active = !pressed

	ray.enabled = active
	line.visible = active


func _on_button_red_pressed_changed(pressed: Variant) -> void:
	active = !pressed

	ray.enabled = active
	line.visible = active


func _on_button_pink_pressed_changed(pressed: Variant) -> void:
	active = !pressed

	ray.enabled = active
	line.visible = active


func _on_button_blue_pressed_changed(pressed: Variant) -> void:
	active = !pressed

	ray.enabled = active
	line.visible = active


func _on_button_green_2_pressed_changed(pressed: Variant) -> void:
	active = !pressed

	ray.enabled = active
	line.visible = active
