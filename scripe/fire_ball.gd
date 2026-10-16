extends CharacterBody2D


# Properti
var arah_terbang : Vector2 = Vector2.RIGHT 
var kecepatan : float = 22950.0
var damage : int = 5
var umur_maksimal : float = 1.0 



@onready var anim:= $AnimatedSprite2D
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D            

var _timer_hidup : float = 0.0

func _ready() -> void:
	# Mulai animasi default (api berputar/bergerak)
	
	if anim:
		anim.play("default")
		
	attack_box.area_entered.connect(nyerang)


	
func _physics_process(delta: float) -> void:
	# Gerakkan fire ball ke arah yang sudah ditentukan
	velocity = arah_terbang * kecepatan * delta
	move_and_slide()

	# Hitung umur fire ball, hancurkan jika sudah melewati batas
	_timer_hidup += delta
	if _timer_hidup >= umur_maksimal:
		queue_free()

#fungsi berhenti obstakle
func nyerang(body):
	print("kill")
	# Jangan merusak player sendiri
	if body.name == "Player" or body.is_in_group("player"):
		print("tes")
		return

	# Jika body punya variabel "darah", kurangi
	if "darah" in body:
		body.darah -= damage
		print("no")
		# Panggil fungsi kena_serang jika ada (untuk trigger animasi/state mati)
		if body.has_method("kena_serang_fireball"):
			body.kena_serang_fireball(damage)
			print('yes')

	# Hancurkan fire ball setelah kena sesuatu
	queue_free()
