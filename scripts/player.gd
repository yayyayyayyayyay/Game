extends CharacterBody2D

var dead := false
var death_state_index := -1
var is_player_one := true
var extra_unlocked = false
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var coyote_timer: Timer = $CoyoteTimer
#@onready var rewind_rect: ColorRect = get_node("/root/Game/CanvasLayer/RewindOverlay")
#@onready var rewind_material := rewind_rect.material as ShaderMaterial
@onready var rewind_overlay := get_tree().get_first_node_in_group("rewind_overlay")
var extra_jump = true

const MAX_HISTORY := 1000
@export var rewind_lerp := 0.85

var rewinding := false
var history := []

class PlayerState:
	var pos: Vector2
	var vel: Vector2
	var anim: String
	var frame: int
	var flip_h: bool

	func _init(p, v, a, f, flip):
		pos = p
		vel = v
		anim = a
		frame = f
		flip_h = flip

func set_rewinding(value: bool) -> void:
	rewinding = value
	if rewinding and dead:
		revive()

func die() -> void:
	if dead:
		return
	dead = true
	death_state_index = history.size()
	velocity = Vector2.ZERO
	#set_collision_mask_value(0, false)
	animated_sprite_2d.stop()
	animated_sprite_2d.modulate = Color(1, 0.4, 0.4)

func revive() -> void:
	dead = false
	if collider:
		collider.disabled = false
	animated_sprite_2d.modulate = Color(1,1,1)
	# Resume normal time
	Engine.time_scale = 1.0

func _physics_process(delta: float) -> void:
	if dead and not rewinding:
		velocity = Vector2.ZERO
		return
	if rewinding:
		start_rewind()
		rewind()
		return

	stop_rewind()
	record_state()

	var was_on_floor = is_on_floor()

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		extra_jump = false

	# Handle jump
	if Input.is_action_just_pressed("jump1") and (is_on_floor() or !coyote_timer.is_stopped() or (extra_jump and extra_unlocked)):
		velocity.y = JUMP_VELOCITY
		extra_jump = false

	var direction := Input.get_axis("move_left1", "move_right1")

	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	# Animations
	if is_on_floor():
		extra_jump = true
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	
	var current_speed = SPEED

	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	var pushing := false

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		var normal = collision.get_normal()

		# Only push if hitting the SIDE (not top/bottom)
		if body and body.is_in_group("pushable") and abs(normal.x) > 0.9:
			body.velocity.x = direction * SPEED*0.5
			pushing = true


	if pushing:
		current_speed *= 0.3

	if was_on_floor and not is_on_floor():
		coyote_timer.start()
		
func record_state() -> void:
	if history.size() >= MAX_HISTORY:
		history.pop_front()

	history.append(
		PlayerState.new(
			global_position,
			velocity,
			animated_sprite_2d.animation,
			animated_sprite_2d.frame,
			animated_sprite_2d.flip_h
		)
	)

func rewind():
	if history.is_empty():
		return

	var state: PlayerState = history.pop_back()

	global_position = global_position.lerp(state.pos, rewind_lerp)
	velocity = state.vel

	animated_sprite_2d.play(state.anim)
	animated_sprite_2d.frame = state.frame
	animated_sprite_2d.flip_h = state.flip_h
	animated_sprite_2d.stop()
	
	if dead and history.size() < death_state_index:
		revive()

func start_rewind() -> void:
	rewinding = true
	velocity = Vector2.ZERO

	if rewind_overlay:
		rewind_overlay.request_rewind_start(is_player_one)

	set_collision_layer_value(1, false)
	set_collision_mask_value(2, false)

func stop_rewind() -> void:
	rewinding = false

	if rewind_overlay:
		rewind_overlay.request_rewind_stop(is_player_one)

	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
