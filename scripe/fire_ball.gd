extends CharacterBody2D

# Properti
var arah_terbang : Vector2 = Vector2.RIGHT 
var kecepatan : float = 18790
var damage : int = 5
var damage_player : int = 5  
var umur_maksimal : float = 2.0 
var penembak : Node2D = null

var _timer_hidup : float = 0.0
var sudah_mengenai : bool = false
var sedang_meledak: bool = false

# Penamaan node untuk mempermudah akses
@onready var anim := $AnimatedSprite2D
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D            
@onready var fire_sprite: AnimatedSprite2D = $AnimatedSprite2D

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
	velocity = arah_terbang * kecepatan * delta
	move_and_slide()

	# Hitung umur fire ball, hancurkan jika sudah melewati batas
	_timer_hidup += delta
	if _timer_hidup >= umur_maksimal:
		set_physics_process(false)
		meledak()


func nyerang(area: Area2D):
	if sudah_mengenai or sedang_meledak or not is_instance_valid(area):
		return

	var target = area.get_parent()
	if not is_instance_valid(target) or target == self or (is_instance_valid(penembak) and target == penembak):
		return

	if target.is_in_group("projektile") or target.is_in_group("player"):
		return
	if not target.is_inside_tree() or not target.is_visible_in_tree():
		return
	if "sudah_mati" in target and bool(target.get("sudah_mati")):
		return
	if "sudah_mati_player" in target and bool(target.get("sudah_mati_player")):
		return
	if target.has_method("is_dead") and bool(target.call("is_dead")):
		return

	# Tandai sudah mengenai agar tidak memicu damage ganda
	sudah_mengenai = true
	if attack_shape:
		attack_shape.set_deferred("disabled", true)

	if target.has_method("kena_serang"):
		target.kena_serang(attack_box)
	elif "darah" in target:
		target.darah -= damage
		if target.has_method("kena_serang_fireball"):
			target.kena_serang_fireball(damage)

	set_physics_process(false)
	meledak()

func meledak() -> void:
	if sedang_meledak:
		return
	sedang_meledak = true
	velocity = Vector2.ZERO
	kecepatan = 0.0
	if attack_box:
		attack_box.set_deferred("monitoring", false)
		attack_box.set_deferred("monitorable", false)
	if attack_shape:
		attack_shape.set_deferred("disabled", true)

	if fire_sprite and fire_sprite.sprite_frames and fire_sprite.sprite_frames.has_animation("meledak"):
		fire_sprite.play("meledak")
		await fire_sprite.animation_finished
	queue_free()
