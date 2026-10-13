extends CharacterBody2D

# ======================================================================
#  FIRE BALL - Projectile yang terbang lurus ke arah player menghadap.
#  Damage: 5  |  Kecepatan: 10000 * delta  |  Hancur setelah 3 detik
# ======================================================================

# --- Properti ---
var arah_terbang : Vector2 = Vector2.RIGHT   # diisi oleh sihir.gd sebelum add_child
var kecepatan : float = 10000.0
var damage : int = 5
var umur_maksimal : float = 3.0              # detik sebelum fire ball hancur sendiri

var _timer_hidup : float = 0.0

func _ready() -> void:
	# Mulai animasi default (api berputar/bergerak)
	var anim = $AnimatedSprite2D
	if anim:
		anim.play("default")

	# Hubungkan signal Area2D untuk mendeteksi tabrakan
	var area = $Area2D
	if area and not area.body_entered.is_connected(_on_body_entered):
		area.body_entered.connect(_on_body_entered)
	if area and not area.area_entered.is_connected(_on_area_entered):
		area.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	# Gerakkan fire ball ke arah yang sudah ditentukan
	velocity = arah_terbang * kecepatan * delta
	move_and_slide()

	# Hitung umur fire ball, hancurkan jika sudah melewati batas
	_timer_hidup += delta
	if _timer_hidup >= umur_maksimal:
		queue_free()

# ---------------------------------------------------------------
#  Saat fire ball menabrak BODY (CharacterBody2D / StaticBody2D)
#  Contoh: menabrak musuh (slime, skeleton, dll) atau tembok.
# ---------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	# Jangan merusak player sendiri
	if body.name == "Player" or body.is_in_group("player"):
		return

	# Jika body punya variabel "darah", kurangi
	if "darah" in body:
		body.darah -= damage
		# Panggil fungsi kena_serang jika ada (untuk trigger animasi/state mati)
		if body.has_method("kena_serang_fireball"):
			body.kena_serang_fireball(damage)

	# Hancurkan fire ball setelah kena sesuatu
	queue_free()

# ---------------------------------------------------------------
#  Saat fire ball menabrak AREA (Area2D lain, misalnya hurtbox musuh)
# ---------------------------------------------------------------
func _on_area_entered(area: Area2D) -> void:
	# Jangan menabrak area milik player sendiri
	if area.get_parent() and (area.get_parent().name == "Player" or area.get_parent().is_in_group("player")):
		return

	# Cari parent dari area (biasanya musuh)
	var target = area.get_parent()
	if target and "darah" in target:
		target.darah -= damage
		if target.has_method("kena_serang_fireball"):
			target.kena_serang_fireball(damage)

	queue_free()

