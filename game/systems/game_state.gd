extends Node

signal coins_changed(total: int)
signal checkpoint_changed
signal level_finished

const START_POSITION = Vector3(0, 0.1, 6)

var coins = 0
var checkpoint_position = START_POSITION
var checkpoint_active = false
var finished = false


func start_new_run() -> void:
	coins = 0
	checkpoint_position = START_POSITION
	checkpoint_active = false
	finished = false


func add_coin() -> void:
	coins += 1
	coins_changed.emit(coins)


func activate_checkpoint(spawn_position: Vector3) -> void:
	checkpoint_position = spawn_position
	checkpoint_active = true
	checkpoint_changed.emit()


func finish_level() -> void:
	if not finished:
		finished = true
		level_finished.emit()
