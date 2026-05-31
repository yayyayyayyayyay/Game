extends Node2D

@export var fireball_scene: PackedScene

@onready var sprite = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var timer = $Timer
@export var start_delay := 0.0

func _ready():
	sprite.play("idle")
	timer.timeout.connect(_shoot)
	if start_delay > 0:
		timer.stop()
		await get_tree().create_timer(start_delay).timeout
		timer.start()

func _shoot():
	# Play recoil animation
	sprite.play("recoil")

	# Spawn fireball
	var fireball = fireball_scene.instantiate()
	get_tree().current_scene.add_child(fireball)

	fireball.global_position = muzzle.global_position
	fireball.direction = Vector2.LEFT.rotated(global_rotation)
	fireball.rotation = global_rotation

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "recoil":
		sprite.play("idle")
