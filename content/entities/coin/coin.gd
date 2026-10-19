class_name Coin
extends Area3D

signal collected(value: int)

@export var value: int = 10


func _ready() -> void:
	add_to_group("coin")
	# body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	rotate_y(2.0 * delta)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		collected.emit(value)
		body.add_coin(value)
		$CollisionShape3D.set_deferred("disabled", true)
		queue_free()
