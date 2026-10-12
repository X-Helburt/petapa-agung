extends Area2D

var slime: CharacterBody2D

func _ready() -> void:
	if get_parent() is CharacterBody2D:
		slime = get_parent()

func slime_mendeteksi(body: Node2D) -> void:
	if body.name == "player":
		if slime and slime.has_method("on_player_terdeteksi"):
			slime.on_player_terdeteksi(body)

func slime_tidak_mendeteksi(body: Node2D) -> void:
	await get_tree().create_timer(0.603).timeout
	if body.name == "player":
		if slime and slime.has_method("on_player_hilang"):
			slime.on_player_hilang(body)
