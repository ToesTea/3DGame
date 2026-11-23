extends CharacterBody3D

@export var speed: float = 6.0
@export var jump_speed: float = 7.4
@export var gravity: float = 18.0

var respawning: bool = false
var bounce_tween: Tween

@onready var visual: Node3D = $Visual
@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D


func _ready() -> void:
	# The camera must collide with the world, but never with its own player.
	spring_arm.add_excluded_object(get_rid())
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotation.y -= event.relative.x * 0.003
		camera_pivot.rotation.x -= event.relative.y * 0.003
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -0.85, 0.15)
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if respawning or GameState.finished:
		return
	# Q and E also turn the camera, so a mouse is not required.
	camera_pivot.rotation.y += Input.get_axis("camera_right", "camera_left") * delta * 1.8
	var was_on_floor: bool = is_on_floor()
	if not was_on_floor:
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and was_on_floor:
		velocity.y = jump_speed
		_bounce(Vector3(0.85, 1.2, 0.85))

	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = camera_pivot.basis * Vector3(input_direction.x, 0, input_direction.y)
	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if direction.length() > 0.1:
		visual.rotation.y = atan2(-direction.x, -direction.z)
	move_and_slide()
	if is_on_floor() and not was_on_floor:
		_bounce(Vector3(1.2, 0.8, 1.2))
	if global_position.y < -8.0:
		respawn()


func respawn() -> void:
	if respawning or GameState.finished:
		return
	respawning = true
	# A deferred teleport is safe even when called by an Area3D signal.
	call_deferred("_return_to_checkpoint")


func _return_to_checkpoint() -> void:
	if bounce_tween:
		bounce_tween.kill()
	$Visual/Body.scale = Vector3.ONE
	$Visual/Body.position.y = 0.6
	global_position = GameState.checkpoint_position
	velocity = Vector3.ZERO
	reset_physics_interpolation()
	await get_tree().create_timer(0.3, false).timeout
	respawning = false


func _bounce(size: Vector3) -> void:
	if bounce_tween:
		bounce_tween.kill()
	# Move the mesh centre with its height, so the feet stay above the floor.
	bounce_tween = create_tween()
	bounce_tween.tween_property($Visual/Body, "scale", size, 0.08)
	bounce_tween.parallel().tween_property($Visual/Body, "position:y", 0.6 * size.y, 0.08)
	bounce_tween.tween_property($Visual/Body, "scale", Vector3.ONE, 0.16)
	bounce_tween.parallel().tween_property($Visual/Body, "position:y", 0.6, 0.16)
