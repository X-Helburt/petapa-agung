extends State



const JEDA_DIAGONAL := 0.1

var timer_jeda_diagonal :  = 0.0
var  arah_diagonal := Vector2.ZERO



func enter() -> void:
	timer_jeda_diagonal = 0.0

func physics_update(_delta):
	# Jika tombol serang ditekan saat sedang jalan, langsung serang
	if Input.is_action_pressed("tombol_serang"):
		player.ubah_state("serang")
	elif Input.is_action_just_pressed("tombol_sihir"):
		player.ubah_state("bola_api")
		return
	
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("kanan"):
		input_dir.x += 1
	if Input.is_action_pressed("kiri"):
		input_dir.x -= 1
	if Input.is_action_pressed("bawah"):
		input_dir.y += 1
	if Input.is_action_pressed("atas"):
		input_dir.y -= 1

	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO

		if timer_jeda_diagonal > 0:
			player.arah_terakhir = arah_diagonal

		player.ubah_state("idle")
		return
	

	if input_dir.x != 0 and input_dir.y != 0:
		arah_diagonal = input_dir
		timer_jeda_diagonal = JEDA_DIAGONAL
		player.arah_terakhir = input_dir

	else:
		if timer_jeda_diagonal > 0:
			timer_jeda_diagonal -= _delta
		else:
			player.arah_terakhir = input_dir



	var animasi = player.get_animasi()
	player.velocity = input_dir.normalized() * player.speed * _delta

	
	# jalan diagonal kanan ke bawah
	if input_dir.x > 0 and input_dir.y > 0:
		animasi.scale.x = 1
		animasi.play("jalan bawah-samping")
	# jalan dagonal kiri ke bawah 
	elif input_dir.x < 0 and input_dir.y > 0:
		animasi.scale.x = -1
		animasi.play("jalan bawah-samping")
	# jalan diagonal kanan ke atas
	elif input_dir.x > 0 and input_dir.y < 0:
		animasi.scale.x = 1
		animasi.play("jalan atas-samping")
	# jalan diagonal kiri ke atas
	elif input_dir.x < 0 and input_dir.y < 0:
		animasi.scale.x = -1
		animasi.play("jalan atas-samping")
	# jalan kanan
	elif input_dir.x > 0:
		animasi.scale.x = 1
		animasi.play("jalan kanan-kiri")
	# jalan kiri
	elif input_dir.x < 0:
		animasi.scale.x = -1
		animasi.play("jalan kanan-kiri")
	# jalan atas
	elif input_dir.y < 0:
		animasi.scale.x = 1
		animasi.play("jalan atas")
	#  jalan bawah
	elif input_dir.y > 0:
		animasi.scale.x = 1
		animasi.play("jalan bawah")
	
