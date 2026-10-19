extends Node

@export var main_menu_scene: PackedScene
@export var settings_scene: PackedScene
@export var pause_menu_scene: PackedScene
@export var gameplay_scene: PackedScene

var current_scene: Node
var pause_menu: Node
var settings_menu: Node
var in_game := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	show_main_menu()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
	if settings_menu != null:
		close_settings()
	elif pause_menu != null:
		close_pause_menu()
	elif in_game:
		open_pause_menu()


func change_scene(next: Node) -> void:
	if current_scene != null:
		current_scene.queue_free()
	current_scene = next
	add_child(current_scene)


func show_main_menu() -> void:
	in_game = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var main_menu := main_menu_scene.instantiate()
	main_menu.start_pressed.connect(start_game)
	main_menu.settings_pressed.connect(open_settings)
	main_menu.exit_pressed.connect(quit_game)
	change_scene(main_menu)


func start_game() -> void:
	in_game = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var gameplay := gameplay_scene.instantiate()
	gameplay.process_mode = Node.PROCESS_MODE_PAUSABLE
	change_scene(gameplay)


func quit_game() -> void:
	get_tree().quit()


func open_pause_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_menu = pause_menu_scene.instantiate()
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.resume_pressed.connect(close_pause_menu)
	pause_menu.settings_pressed.connect(open_settings)
	pause_menu.main_menu_pressed.connect(go_to_main_menu)
	add_child(pause_menu)
	get_tree().paused = true


func close_pause_menu() -> void:
	pause_menu.queue_free()
	pause_menu = null
	get_tree().paused = false
	if in_game:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func go_to_main_menu() -> void:
	close_pause_menu()
	show_main_menu()


func open_settings() -> void:
	settings_menu = settings_scene.instantiate()
	settings_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	settings_menu.back_pressed.connect(close_settings)
	add_child(settings_menu)


func close_settings() -> void:
	settings_menu.queue_free()
	settings_menu = null
