class_name Gameplay
extends Node3D

@export var coin_scene: PackedScene
@export var spawn_range := 15.0

var score := 0

@onready var hud = $Score


func _ready() -> void:
	for coin in get_tree().get_nodes_in_group("coin"):
		if not coin.collected.is_connected(_on_coin_collected):
			coin.collected.connect(_on_coin_collected)

func _on_coin_collected(value: int) -> void:
	_add_score(value)
	_spawn_coin()


func _add_score(points: int) -> void:
	score += points
	hud.update_score(score)


func _spawn_coin() -> void:
	var coin: Coin = coin_scene.instantiate()
	coin.collected.connect(_on_coin_collected)
	add_child(coin)
	coin.position = Vector3(
		randf_range(-spawn_range, spawn_range),
		1.0,
		randf_range(-spawn_range, spawn_range))
