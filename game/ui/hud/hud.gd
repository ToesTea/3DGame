extends CanvasLayer

var required_coins = 8


func _ready() -> void:
	GameState.coins_changed.connect(_update_coins)
	GameState.checkpoint_changed.connect(_update_checkpoint)
	_update_coins(GameState.coins)
	_update_checkpoint()


func set_goal(amount: int) -> void:
	required_coins = amount
	_update_coins(GameState.coins)


func _update_coins(total: int) -> void:
	$Root/Top/Coins.text = "Coins: %d / %d" % [total, required_coins]


func _update_checkpoint() -> void:
	if GameState.checkpoint_active:
		$Root/Top/Checkpoint.text = "Checkpoint saved"
	else:
		$Root/Top/Checkpoint.text = "No checkpoint"
