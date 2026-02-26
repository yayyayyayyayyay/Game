extends CanvasLayer

@onready var anim = $AnimationPlayer

func fade_to_scene(target_scene: String):
	# Fade to black
	anim.play("fade")
	await anim.animation_finished
	
	# Change scene
	get_tree().change_scene_to_file(target_scene)
	
	# Fade back in
	anim.play_backwards("fade")
