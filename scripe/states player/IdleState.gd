extends State

func enter():
	var animasi = player.get_animasi()
	player.velocity = Vector2.ZERO
	var arah = player.arah_terakhir
	if arah == null:
		arah = Vector2.DOWN
		player.arah_terakhir = arah
	
	# idle diagonal kanan ke bawah
	if arah.x > 0 and arah.y > 0:
		animasi.scale.x = 1
		animasi.play("diem bawah-samping")
	# idle diagonal kiri ke bawah 
	elif arah.x < 0 and arah.y > 0:
		animasi.play("diem bawah-samping")
		animasi.scale.x = -1
	# idle diagonal atas ke kanan
	elif arah.x > 0 and arah.y < 0:
		animasi.play("diem atas-samping")
		animasi.scale.x = 1
	# idle diagonal atas ke kiri
	elif arah.x < 0 and arah.y < 0:
		animasi.play("diem atas-samping")
		animasi.scale.x = -1
	# idle kanan
	elif arah.x > 0 and arah.y == 0:
		animasi.play("diem kesamping")
		animasi.scale.x = 1
	# idle kiri
	elif arah.x < 0 and arah.y == 0:
		animasi.play("diem kesamping")
		animasi.scale.x = -1
	# idle atas
	elif arah.y < 0 and arah.x == 0:
		animasi.play("diem atas")
		animasi.scale.x = 1
	# idle bawah
	elif arah.y > 0 and arah.x == 0:
		animasi.play("diem bawah")
		animasi.scale.x = 1
	else:
		animasi.play("diem bawah")


func physics_update(_delta):
	# Utamakan serangan jika tombol_serang ditekan
	if Input.is_action_pressed("tombol_serang"):
		player.ubah_state("serang")
		return

	# kalau ada input arah, pindah ke JalanState
	if Input.is_action_pressed("bawah") and Input.is_action_pressed("kanan") \
	or Input.is_action_pressed("bawah") and Input.is_action_pressed("kiri") \
	or Input.is_action_pressed("atas") and Input.is_action_pressed("kanan") \
	or Input.is_action_pressed("atas") and Input.is_action_pressed("kiri") \
	or Input.is_action_pressed("kanan") \
	or Input.is_action_pressed("kiri") \
	or Input.is_action_pressed("atas") \
	or Input.is_action_pressed("bawah"):
		player.ubah_state("jalan")
