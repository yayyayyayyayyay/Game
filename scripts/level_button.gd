extends Button

@export var level_index := 0
@export var level_scene := ""

func _ready():

	text = str(level_index + 1)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)

func _on_hover():
	scale = Vector2(1.1, 1.1)

func _on_exit():
	scale = Vector2.ONE
