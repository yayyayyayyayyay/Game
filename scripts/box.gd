extends CharacterBody2D

@export var rewindable := false
@export var gravity := 1000.0
@onready var sprite = $Sprite2D
const MAX_HISTORY := 500
var history := []

class BoxState:
	var pos: Vector2

	func _init(p):
		pos = p

func _ready():
	add_to_group("pushable")
	if rewindable:
		sprite.modulate = Color(0.6, 1.0, 0.6)

func record_state():
	if history.size() >= MAX_HISTORY:
		history.pop_front()

	history.append(
		BoxState.new(global_position)
	)

func _physics_process(delta):	
	if rewindable and should_rewind():
		rewind()
		return
	if rewindable:
		record_state()
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

	# STOP horizontal movement AFTER moving
	velocity.x = 0

func should_rewind() -> bool:
	var players = get_tree().get_nodes_in_group("player")

	for p in players:
		if p.rewinding:
			return true

	return false

func rewind():
	if history.is_empty():
		return

	var state = history.pop_back()

	global_position = state.pos
	velocity = Vector2.ZERO
