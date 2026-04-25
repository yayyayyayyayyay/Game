extends CharacterBody2D

@export var gravity := 1000.0

func _ready():
	add_to_group("pushable")
	add_to_group("pressable") # for buttons later

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Slow horizontal movement (fake friction)
	velocity.x = move_toward(velocity.x, 0, 400 * delta)

	move_and_slide()
