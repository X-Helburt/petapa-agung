extends State

func enter() -> void:
	player.sudah_mati_player = true
	player.velocity = Vector2.ZERO
	
	# Hentikan timer regenerasi bila sedang aktif
	if player.regen_player:
		player.regen_player.stop()
	
	# Matikan area serangan dan hurtbox
	player.set_attack_box_active(false)
	if player.hurtbox_player:
		player.hurtbox_player.set_deferred("monitoring", false)
	if player.collision_player:
		player.collision_player.set_deferred("disabled", true)
	
	# Putar animasi mati
	var animasi = player.get_animasi()
	if animasi:
		if animasi.sprite_frames and animasi.sprite_frames.has_animation("mati"):
			animasi.sprite_frames.set_animation_loop("mati", false)
		animasi.play("mati")
		await animasi.animation_finished
	player.hide()
	await player.get_tree().create_timer(2.5).timeout
	player.respawn()

func handle_input(_event: InputEvent) -> void:
	# Abaikan semua input kontrol saat player dalam kondisi mati
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	player.velocity = Vector2.ZERO
