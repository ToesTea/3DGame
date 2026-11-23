extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not GameState.checkpoint_active:
		GameState.activate_checkpoint($SpawnPoint.global_position)
		$Label.text = "Checkpoint saved"
