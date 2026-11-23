extends Area3D

@export_range(1, 12) var required_coins: int = 8
var unlocked: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	GameState.coins_changed.connect(_update_coins)
	_update_coins(GameState.coins)


func _update_coins(total: int) -> void:
	if total < required_coins:
		$Label.text = "LANTERN GATE\n%d / %d coins" % [total, required_coins]
		return
	$Label.text = "GATE OPEN\nStep into the light"
	unlocked = true
	$Gate.hide()
	# Also finish if the final coin was collected while already in the goal.
	call_deferred("_check_players")


func _check_players() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			GameState.finish_level()


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	if unlocked:
		GameState.finish_level()
