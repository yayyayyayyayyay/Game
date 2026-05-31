extends Area2D

@export var speed := 100.0
var direction := Vector2.LEFT


func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play()
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if not body.is_in_group("player"):
		queue_free()
