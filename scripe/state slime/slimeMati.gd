extends slime_state

func enter() -> void:
	if slime:
		slime.velocity = Vector2.ZERO
		slime.musuh_mati()
