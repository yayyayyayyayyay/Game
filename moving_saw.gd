extends Path2D

@export var speed := 5.0
@export var one_shot = true
@export var replay = false
@onready var follower = $PathFollow2D
var direction := 1

func _process(delta):
	if one_shot:
		if follower.progress_ratio >= 1.0:
			return
	else:
		if !replay:
			if follower.progress_ratio >= 1.0:
				direction = -1

			elif follower.progress_ratio <= 0.0:
				direction = 1
		else:
			if follower.progress_ratio >= 1.0:
				follower.progress_ratio = 0.0
	

	follower.progress += speed * direction * delta
