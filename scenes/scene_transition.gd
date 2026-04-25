extends CanvasLayer

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("fade")
	anim.seek(anim.current_animation_length) # jump to end (fully black)
	anim.stop()

func fade_to_black():
	anim.play("fade")
	await anim.animation_finished

func fade_from_black():
	anim.play_backwards("fade")
	
