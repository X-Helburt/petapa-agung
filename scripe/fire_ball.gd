extends CharacterBody2D


# Properti
var arah_terbang : Vector2 = Vector2.RIGHT   # diisi oleh sihir.gd sebelum add_child
var kecepatan : float = 10000.0
var damage : int = 5
var umur_maksimal : float = 3.0  

@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D            

var _timer_hidup : float = 0.0

func _ready() -> void:
	# Mulai animasi default (api berputar/bergerak)
	var anim = $AnimatedSprite2D
	if anim:
		anim.play("default")

	# Hubungkan signal Area2D untuk mendeteksi tabrakan
	set_attack_box_active(false)
	
func _physics_process(delta: float) -> void:
	# Gerakkan fire ball ke arah yang sudah ditentukan
	set_attack_box_active(true)
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

func set_attack_box_active(active: bool) -> void:
	if attack_box:
		attack_box.set_deferred("monitoring", active)
		attack_box.set_deferred("monitorable", active)
	if attack_shape:
		attack_shape.set_deferred("disabled", !active)
