extends slime_state


const JARAK_SERANG: float = 24.0

func enter() -> void:
	if slime and slime.sprite:
		slime.sprite.play("slime jalan")

func physics_update(_delta: float) -> void:
	if not slime or not slime.target_player:
		slime.change_state_slime("slime idle")
		return

	var arah = slime.target_player.global_position - slime.global_position
	var jarak = arah.length()

	# Jika sudah dekat dengan player, beralih ke state serang
	if jarak <= JARAK_SERANG:
		slime.change_state_slime("slime serang")
		return

	# Bergerak mendekati player
	slime.velocity = arah.normalized() * slime.kecepatan_slime

	# Flip sprite horizontal sesuai arah gerak
	if arah.x < 0:
		slime.sprite.flip_h = true
	elif arah.x > 0:
		slime.sprite.flip_h = false

func exit() -> void:
	if slime:
		slime.velocity = Vector2.ZERO
