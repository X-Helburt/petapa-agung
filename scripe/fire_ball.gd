extends CharacterBody2D

# Properti
var arah_terbang : Vector2 = Vector2.RIGHT 
var kecepatan : float = 200.0
var damage : int = 5
var damage_player : int = 5  
var umur_maksimal : float = 2.0 
var penembak : Node2D = null

var _timer_hidup : float = 0.0
var sudah_mengenai : bool = false

# Penamaan node untuk mempermudah akses
@onready var anim := $AnimatedSprite2D
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D            


func _ready() -> void:
	# Jalankan animasi
	if anim:
		if anim.sprite_frames and anim.sprite_frames.has_animation("fire_ball"):
			anim.play("fire_ball")
		elif anim.sprite_frames and anim.sprite_frames.has_animation("default"):
			anim.play("default")
	
	# Pastikan AttackBox dapat mendeteksi dan dideteksi
	attack_box.monitoring = true
	attack_box.monitorable = true
	if attack_shape:
		attack_shape.disabled = false
		
	if not attack_box.area_entered.is_connected(nyerang):
		attack_box.area_entered.connect(nyerang)


func _physics_process(delta: float) -> void:
	# Gerakkan fire ball ke arah yang sudah ditentukan
	velocity = arah_terbang * kecepatan
	move_and_slide()

	# Hitung umur fire ball, hancurkan jika sudah melewati batas
	_timer_hidup += delta
	if _timer_hidup >= umur_maksimal:
		queue_free()


func nyerang(area: Area2D):
	if sudah_mengenai or not area:
		return

	var target = area.get_parent()

	# Abaikan jika target adalah fireball itu sendiri atau si player
	if  target.is_in_group("player"):
		return

	# Tandai sudah mengenai agar tidak memicu damage ganda
	sudah_mengenai = true
	if attack_shape:
		attack_shape.set_deferred("disabled", true)

	var musuh = target if target else area

	# Jika musuh memiliki fungsi kena_serang (seperti slime.gd atau tengkorang.gd)
	if musuh and musuh.has_method("kena_serang"):
		# Kirimkan attack_box fireball ini agar musuh memproses damage_player (5) dan animasi/darahnya
		musuh.kena_serang(attack_box)
	elif musuh and "darah" in musuh:
		# Fallback jika musuh tidak punya method kena_serang standar
		musuh.darah -= damage
		if musuh.has_method("kena_serang_fireball"):
			musuh.kena_serang_fireball(damage)


	queue_free()
