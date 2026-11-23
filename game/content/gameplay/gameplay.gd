extends Node3D


func _ready() -> void:
	$Player.global_position = GameState.checkpoint_position
	$HUD.set_goal($Level02/Goal.required_coins)
