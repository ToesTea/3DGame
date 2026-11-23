extends Area3D

var collected: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if collected:
		return
	$Visual.rotation.y += delta * 2.2


func _on_body_entered(body: Node3D) -> void:
	if collected or not body.is_in_group("player"):
		return
	if GameState.finished:
		return
	GameState.add_coin()
	collected = true
	$CollisionShape3D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property($Visual, "scale", Vector3.ZERO, 0.25)
	tween.tween_callback(queue_free)
