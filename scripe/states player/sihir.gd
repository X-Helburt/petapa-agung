extends State

# Preload scene fire_ball.tscn
var fire_ball_scene : PackedScene = preload("res://scene/player/panah/fire_ball.tscn")

func enter() -> void:
	# Spawn fire ball ke arah terakhir player, lalu langsung kembali ke idle
	serang_fireball(player.arah_terakhir)

func exit() -> void:
	pass


func serang_fireball(arah: Vector2) -> void:
	var bola_api = fire_ball_scene.instantiate()

	# 2) Beri tahu fire_ball arah terbangnya SEBELUM ditambahkan ke scene
	#    (fire_ball.gd punya variabel "arah_terbang" yang akan dipakai di _physics_process)
	if arah == Vector2.ZERO:
		arah = Vector2.RIGHT  # default ke kanan kalau tidak ada arah
	bola_api.arah_terbang = arah.normalized()

	# 3) Flip sprite fire ball sesuai arah horizontal
	var sprite = bola_api.get_node("AnimatedSprite2D")
	if sprite:
		if arah.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1

	# 4) Tambahkan ke scene utama (bukan child player, supaya fire ball
	#    tidak ikut bergerak saat player bergerak)
	player.get_tree().current_scene.add_child(bola_api)

	# 5) Set posisi fire ball = posisi player saat ini
	bola_api.global_position = player.global_position

	# 6) Kembali ke state idle setelah menembak
	player.ubah_state("idle")
