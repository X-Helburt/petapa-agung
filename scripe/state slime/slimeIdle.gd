extends slime_state

func enter() -> void:
	if slime:
		slime.velocity = Vector2.ZERO
		if slime.sprite:
			slime.sprite.play("slime idle")

func physics_update(_delta: float) -> void:
	if slime and slime.target_player:
		slime.ubah_state_slime("slime jalan")
