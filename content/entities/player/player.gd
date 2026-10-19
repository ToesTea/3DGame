class_name Player
extends CharacterBody3D

@export var jump_velocity := 8.0
@export var gravity := 22.0
@export var mouse_sensitivity := 0.003

var coins := 0
var spawn_position: Vector3

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var mesh: Node3D = $MeshInstance3D


func _ready() -> void:
	add_to_group("player")
	spawn_position = global_position


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
		spring_arm.rotation.x = clampf(
			spring_arm.rotation.x - event.relative.y * mouse_sensitivity,
			deg_to_rad(-70), deg_to_rad(20))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var yaw := Basis(Vector3.UP, spring_arm.rotation.y)
	var direction := yaw * Vector3(input_dir.x, 0, input_dir.y)

	if direction.length() > 0.1:
		direction = direction.normalized()
		velocity.x = direction.x * Settings.speed
		velocity.z = direction.z * Settings.speed
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-direction.x, -direction.z), 10 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, Settings.speed)
		velocity.z = move_toward(velocity.z, 0, Settings.speed)

	move_and_slide()

	if global_position.y < -20:
		global_position = spawn_position
		velocity = Vector3.ZERO


func add_coin(value: int) -> void:
	coins += value
