extends State


func enter():
	var animasi = player.get_animasi()
	
	# Pastikan animasi serangan tidak looping agar signal animation_finished terpanggil
	if animasi.sprite_frames:
		animasi.sprite_frames.set_animation_loop("serang samping", false)
		animasi.sprite_frames.set_animation_loop("serang atas", false)
		animasi.sprite_frames.set_animation_loop("serang bawah", false)

	# Hubungkan signal animation_finished jika belum terhubung
	if not animasi.animation_finished.is_connected(_on_animation_finished):
		animasi.animation_finished.connect(_on_animation_finished)
	
	# Cek apakah ada input arah baru saat mulai menyerang
	var arah_sekarang = get_arah_sekarang()
	if arah_sekarang != Vector2.ZERO:
		player.arah_terakhir = arah_sekarang
		
	
	setup_animasi_serang(player.arah_terakhir, animasi)

func exit():
	var animasi = player.get_animasi()
	if animasi.animation_finished.is_connected(_on_animation_finished):
		animasi.animation_finished.disconnect(_on_animation_finished)
	
	# Pastikan Hitbox mati saat keluar dari state serangan
	player.set_attack_box_active(false)

func get_arah_sekarang() -> Vector2:
	var arah = Vector2.ZERO
	if Input.is_action_pressed("kanan"):
		arah.x += 1
	if Input.is_action_pressed("kiri"):
		arah.x -= 1
	if Input.is_action_pressed("bawah"):
		arah.y += 1
	if Input.is_action_pressed("atas"):
		arah.y -= 1
	
	return arah

func setup_animasi_serang(arah: Vector2, animasi: AnimatedSprite2D):
	# serang dagonal kanan ke bawah
	if arah.x > 0 and arah.y > 0:
		animasi.play("serang bawah-samping")
		animasi.scale.x = 1
	# serang diagonal kiri ke bawah
	elif arah.x < 0 and arah.y > 0:
		animasi.play("serang bawah-samping")
		animasi.scale.x = -1
	# serang diagonal kanan ke atas
	elif arah.x > 0 and arah.y < 0:
		animasi.play("serang atas-samping")
		animasi.scale.x = 1
	# serang diagonal kiri atas
	elif arah.x < 0 and arah.y < 0:
		animasi.play("serang atas-samping")
		animasi.scale.x = -1
	# serang kanan
	elif arah.x > 0:
		animasi.play("serang samping")
		animasi.scale.x = 1
	# serang kiri
	elif arah.x < 0:
		animasi.play("serang samping")
		animasi.scale.x = -1
	# serang atas
	elif arah.y < 0:
		animasi.play("serang atas")
	# serang bawah
	elif arah.y > 0:
		animasi.play("serang bawah")
	else:
		animasi.play("serang bawah")
		

func physics_update(_delta):
	# Pertahankan posisi/kecepatan player tetap berhenti saat sedang menyerang
	player.velocity = Vector2.ZERO

func _on_animation_finished():
	# Ketika animasi serangan selesai, otomatis kembali ke idle atau jalan
	var arah_saat_ini = get_arah_sekarang()
	if arah_saat_ini != Vector2.ZERO:
		player.ubah_state("jalan")
	else:
		player.ubah_state("idle")
