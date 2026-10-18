extends CharacterBody2D


# properti
const KECEPATAN : float = 17891
const MAX_DARAH : int = 10

var sudah_mati_player : bool = false
var kebal_player : bool = false

var state: State
var states = {}
var vel = Vector2.ZERO
var arah_terakhir = Vector2.RIGHT

var darah_tameng : int = 5
var darah : int = MAX_DARAH
var tameng : int = 2
var regen : int = 1

var debuff_slow : float = 1.0
var debuff_damage : int = 1


var speed : float = KECEPATAN * debuff_slow
var damage_player : int = 2 * debuff_damage

var posisi_awal : Vector2 = Vector2.ZERO

# penamaan node untuk mempermudah akses
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D 
@onready var darah_player: Label = $"Darah Player"
@onready var hurtbox_player: Area2D = $hurtbox
@onready var collision_player: CollisionShape2D = $CollisionShape2D
@onready var regen_player: Timer = $regen


func _ready():
	posisi_awal = global_position

	# Load states
	states["idle"] =preload("res://scripe/states player/IdleState.gd").new()
	states["jalan"] = preload("res://scripe/states player/JalanState.gd").new()
	states["serang"] =preload("res://scripe/states player/SerangState.gd").new()
	states["mati"] =preload("res://scripe/states player/MatiState.gd").new()
	states["state"] = preload("res://scripe/states player/State.gd").new()
	states["bola_api"] = preload("res://scripe/states player/sihir.gd").new()
	

	if darah_player:
		darah_player.text = str(darah_tameng) + "
		" + str(darah)

	# Kasih referensi player ke setiap state
	for s in states.values():
		s.player = self

	# Matikan attack_box di awal game
	set_attack_box_active(false)

	# Hubungkan signal frame_changed jika belum terhubung
	if not animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)

	# Hubungkan signal hurtbox untuk mendeteksi serangan musuh
	if hurtbox_player and not hurtbox_player.area_entered.is_connected(kena_serang):
		hurtbox_player.area_entered.connect(kena_serang)

	# Hubungkan signal timeout untuk regenerasi darah
	if regen_player and not regen_player.timeout.is_connected(_on_regen_timeout):
		regen_player.timeout.connect(_on_regen_timeout)

	ubah_state("idle")

func get_animasi() -> AnimatedSprite2D:
	return animated_sprite

func ubah_state(new_state: String):
	if state:
		state.exit()
	if states.has(new_state):
		state = states[new_state]
		state.enter()

func _input(event):
	if state:
		state.handle_input(event)

func _process(delta):
	if state:
		state.update(delta)

func _physics_process(delta):
	if state:
		state.physics_update(delta)
	move_and_slide()

# Helper function untuk menyalakan/mematikan AttackBox dengan aman
func set_attack_box_active(active: bool) -> void:
	if attack_box:
		attack_box.set_deferred("monitoring", active)
		attack_box.set_deferred("monitorable", active)
	if attack_shape:
		attack_shape.set_deferred("disabled", !active)

func _on_animated_sprite_2d_frame_changed():
	if animated_sprite.animation.begins_with("serang") and animated_sprite.frame == 1:
		set_attack_box_active(true)
	else:
		set_attack_box_active(false)

# Fungsi saat player terkena serangan musuh
func kena_serang(area: Area2D) -> void:
	if sudah_mati_player or kebal_player:
		return
	
	if area.get_parent() == self:
		return 

	if area.name == "AttackBox" and (area.monitoring or area.monitorable):
		var musuh_node = area.get_parent()
		var damage_diterima = 1
		if musuh_node:
			if "damage_musuh" in musuh_node:
				damage_diterima = musuh_node.damage_musuh
			elif "damage" in musuh_node:
				damage_diterima = musuh_node.damage
		
		darah_tameng -= damage_diterima / tameng
		if darah_player:
			darah_player.text = str(darah_tameng) + "
		" + str(darah)
		
		if darah_tameng <= 0:
			darah -= damage_diterima / tameng
			
			darah_player.text = str(darah)
		if darah <= 0:
			ubah_state("mati")
		else:
			# Efek visual kedip merah saat terkena serangan
			kebal_player = true
			animated_sprite.modulate = Color(1.8, 0.4, 0.4)
			if darah_player:
				darah_player.show()
			
			# Reset dan hitung ulang waktu jeda regen (tunggu 4 detik)
			if regen_player:
				regen_player.stop()
				regen_player.start(4.0)
			
			await get_tree().create_timer(0.2).timeout
			animated_sprite.modulate = Color.WHITE
			kebal_player = false

# Handler regenerasi darah
func _on_regen_timeout() -> void:
	if sudah_mati_player:
		return
	
	if darah < MAX_DARAH:
		darah += regen
		darah = min(darah, MAX_DARAH)
		if darah_player:
			darah_player.text = str(darah)
		
		# Jika belum penuh, lanjutkan regenerasi setiap 1 detik
		if darah < MAX_DARAH:
			regen_player.start(1.0)
		else:
			regen_player.stop()

# Fungsi untuk respawn player setelah mati
func respawn() -> void:
	global_position = posisi_awal
	sudah_mati_player = false
	kebal_player = false
	darah = MAX_DARAH
	
	if darah_player:
		darah_player.text = str(darah)
		darah_player.show()
	
	if collision_player:
		collision_player.set_deferred("disabled", false)
	
	if hurtbox_player:
		hurtbox_player.set_deferred("monitoring", true)
	
	animated_sprite.modulate = Color.WHITE
	show()
	ubah_state("idle")
