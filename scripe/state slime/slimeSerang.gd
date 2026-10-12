extends slime_state

func enter() -> void:
	if slime:
		slime.velocity = Vector2.ZERO
		if slime.sprite:
			if slime.sprite.sprite_frames:
				slime.sprite.sprite_frames.set_animation_loop("slime nyerang", false)
			if not slime.sprite.animation_finished.is_connected(_on_animation_finished):
				slime.sprite.animation_finished.connect(_on_animation_finished)
			slime.sprite.play("slime nyerang")

func exit() -> void:
	if slime:
		if slime.sprite and slime.sprite.animation_finished.is_connected(_on_animation_finished):
			slime.sprite.animation_finished.disconnect(_on_animation_finished)
		slime.set_attack_box_active(false)

func _on_animation_finished() -> void:
	var _slime_setelahnya = randf()
	if slime and slime.state == self:
		if slime.target_player:
			slime.ubah_state_slime("slime jalan")
		# elif slime_setelahnya > 0.5:
		# 	_slime.ubah_state_slime("slime action")
		else:
			slime.ubah_state_slime("slime idle")
