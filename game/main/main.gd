extends Node

@export var main_menu_scene: PackedScene
@export var pause_menu_scene: PackedScene
@export var game_play_scene: PackedScene

const RESULT_SCENE: PackedScene = preload("res://ui/menus/result_menu/result_menu.tscn")

var _current: Node
var _gameplay: Node
var _pause_menu: CanvasLayer
var _result: CanvasLayer


func _ready() -> void:
	GameState.level_finished.connect(_on_level_finished)
	_show_main_menu()


func _unhandled_input(event: InputEvent) -> void:
	if is_instance_valid(_result):
		return
	if event.is_action_pressed("pause") and _is_gameplay_active():
		if is_instance_valid(_pause_menu):
			_close_pause_menu()
		else:
			_open_pause_menu()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("restart") and _is_gameplay_active() and not get_tree().paused:
		_show_result(false)
		get_viewport().set_input_as_handled()


func _show_main_menu() -> void:
	_close_overlays()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var menu := main_menu_scene.instantiate()
	menu.start_pressed.connect(_start_game)
	menu.exit_pressed.connect(_exit_game)
	_switch_to(menu)
	_gameplay = null


func _start_game() -> void:
	_close_overlays()
	get_tree().paused = false
	GameState.start_new_run()
	var game := game_play_scene.instantiate()
	_switch_to(game)
	_gameplay = game


func _open_pause_menu() -> void:
	_pause_menu = pause_menu_scene.instantiate()
	_pause_menu.resume_pressed.connect(_close_pause_menu)
	_pause_menu.restart_pressed.connect(_show_result.bind(false))
	_pause_menu.main_menu_pressed.connect(_show_main_menu)
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	add_child(_pause_menu)


func _close_pause_menu() -> void:
	if is_instance_valid(_pause_menu):
		_pause_menu.queue_free()
	_pause_menu = null
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _show_result(won: bool) -> void:
	if is_instance_valid(_pause_menu):
		_pause_menu.queue_free()
	_pause_menu = null
	_result = RESULT_SCENE.instantiate()
	_result.victory = won
	_result.restart_pressed.connect(_start_game)
	_result.main_menu_pressed.connect(_show_main_menu)
	_result.cancel_pressed.connect(_close_result)
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	add_child(_result)


func _on_level_finished() -> void:
	# Finish may be emitted inside a physics query. Change screens afterwards.
	call_deferred("_show_result", true)


func _close_result() -> void:
	_result.queue_free()
	_result = null
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _close_overlays() -> void:
	if is_instance_valid(_pause_menu):
		_pause_menu.queue_free()
	if is_instance_valid(_result):
		_result.queue_free()
	_pause_menu = null
	_result = null


func _is_gameplay_active() -> bool:
	return is_instance_valid(_gameplay) and _current == _gameplay


func _switch_to(next: Node) -> void:
	if is_instance_valid(_current):
		remove_child(_current)
		_current.queue_free()
	_current = next
	add_child(_current)


func _exit_game() -> void:
	get_tree().quit()
