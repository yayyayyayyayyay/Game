extends CharacterBody2D

@export var gravity := 1000.0

func _ready():
	add_to_group("pushable")

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

	# STOP horizontal movement AFTER moving
	velocity.x = 0
