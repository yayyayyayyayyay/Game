extends CanvasLayer

@onready var rect: ColorRect = $RewindOverlay
@onready var material: ShaderMaterial = rect.material

var player1_r := false
var player2_r := false
func _ready():
	if rect == null:
		push_error("RewindOverlay: ColorRect node not found")
	if material == null:
		push_error("RewindOverlay: ShaderMaterial not assigned")

func request_rewind_start(player1):
	if(player1): player1_r = true
	else: player2_r = true
	material.set_shader_parameter("strength", 1.00 if (player1_r || player2_r) else 0.0)

func request_rewind_stop(player1):
	if(player1): player1_r = false
	else: player2_r = false
	material.set_shader_parameter("strength", 1.00 if (player1_r || player2_r) else 0.0)
