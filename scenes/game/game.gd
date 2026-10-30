extends Node2D
class_name Game

@onready var player: Player = $Player 

func _ready() -> void:
	EventManager.on_player_dead.connect(_on_player_died)

func _on_player_died() -> void:
	player.player_died()
