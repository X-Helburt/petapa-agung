extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox
@onready var collision := $CollisionShape2D
@onready var label_slime : Label = $Darah
@onready var regen: Timer = $regen
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D

const MAX_DARAH: int = 6
const SPEED: float = 154.78

var state : slime_state
var states = {}
var darah : int = MAX_DARAH
var sudah_mati : bool = false
var kebal : bool = false
var regen_slime : int = 1
var damage_slime := 2
var damage_musuh := 2
var kecepatan_slime := SPEED
var target_player: CharacterBody2D = null


func _ready():
	states["slime idle"] = preload("res://scripe/state slime/slimeIdle.gd").new()
	states["slime jalan"] = preload("res://scripe/state slime/slimeJalan.gd").new()
	states["slime serang"] = preload("res://scripe/state slime/slimeSerang.gd").new()
	states["slime mati"] = preload("res://scripe/state slime/slimeMati.gd").new()

	# referensi tubuh slime ke states
	for s in states.values():
		s.slime = self # mengisi variable slime di states

	# Matikan attack_box di awal game
	set_attack_box_active(false)

	# Hubungkan signal frame_changed jika belum terhubung
	if not sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)

	# menghubungkan hitbox
	if hitbox.area_entered and not hitbox.area_entered.is_connected(kena_serang):
		hitbox.area_entered.connect(kena_serang)

	change_state_slime("slime idle")

func change_state_slime(new_state: String):
	if state:
		state.exit()
	if states.has(new_state):
		state = states[new_state]
		state.enter()

func set_attack_box_active(active: bool) -> void:
	if attack_box:
		attack_box.set_deferred("monitoring", active)
		attack_box.set_deferred("monitorable", active)
	if attack_shape:
		attack_shape.set_deferred("disabled", !active)

func _on_animated_sprite_2d_frame_changed():
	if sprite.animation == "slime nyerang" and sprite.frame == 1:
		set_attack_box_active(true)
	else:
		set_attack_box_active(false)

func on_player_terdeteksi(player_node: CharacterBody2D) -> void:
	target_player = player_node
	if not sudah_mati and state != states.get("slime serang") and state != states.get("slime mati"):
		change_state_slime("slime jalan")

func on_player_hilang(player_node: CharacterBody2D) -> void:
	var slime_kerjaan = randf()
	if target_player == player_node:
		target_player = null
		if not sudah_mati and state != states.get("slime serang") and state != states.get("slime mati"):
			change_state_slime("slime idle")
			if slime_kerjaan > 0.5:
				print("jalan")
			else:
				print("di")

func _process(delta):
	if state:
		state.update(delta)
	

func _physics_process(delta):
	if state:
		state.physics_update(delta)
	move_and_slide()

#terkena serang
func kena_serang(area):
	if sudah_mati or kebal:
		return

	if area.get_parent() == self:
		return
		
	if area.name == "AttackBox" and (area.monitoring or area.monitorable):
		var player_node = area.get_parent()
		var damage_diterima = 1
		if player_node and "damage_player" in player_node:
			damage_diterima = player_node.damage_player
		# darah slime
		darah -= damage_diterima
		if darah <= 0:
			label_slime.hide()
			change_state_slime("slime mati")
		else:
			# Efek visual kedip merah saat terkena serangan
			kebal = true
			sprite.modulate = Color(1.8, 0.4, 0.4)
			label_slime.show()
			regen.start(4)
			label_slime.text = str(darah)
			await get_tree().create_timer(0.2).timeout
			sprite.modulate = Color.WHITE
			kebal = false
			
			
func musuh_mati():
	sudah_mati = true
	target_player = null
	hitbox.set_deferred("monitoring", false)
	set_physics_process(false)
	set_process(false)
	
	if sprite.sprite_frames:
		sprite.sprite_frames.set_animation_loop("slime mati", false)
	
	sprite.play("slime mati")
	await sprite.animation_finished
	
	collision.set_deferred("disabled", true)
	hide()
	drop_slime()
	await get_tree().create_timer(2.5).timeout
	show()
	respawn()

func respawn():
	sudah_mati = false
	kebal = false
	darah = MAX_DARAH
	sprite.modulate = Color.WHITE
	sprite.play("slime idle")
	collision_layer = 0
	collision_mask = 0
	
	var tanah = get_parent().get_node("tanah") as TileMapLayer
	if tanah:
		var current_cell = tanah.local_to_map(position)
		for i in 20:
			var random_cell = Vector2i(
				current_cell.x + randi_range(-6, 5),
				current_cell.y + randi_range(-5, 6)
			)
			if tanah.get_cell_source_id(random_cell) != -1:
				global_position = tanah.map_to_local(random_cell)
				break
	
	await get_tree().create_timer(0.1).timeout
	collision_layer = 1
	collision_mask = 1
	
	hitbox.set_deferred("monitoring", true)
	collision.set_deferred("disabled", false)
	set_physics_process(true)
	set_process(true)
	change_state_slime("slime idle")


func _on_regen_timeout() -> void:
	if darah < MAX_DARAH:
		darah += regen_slime
		label_slime.text = str(darah)
		
		
		
func drop_slime() -> void:
	var loot = randf()
	var item = randi_range(0, 10)
	if loot <= 0.6:
		print('ok', item)
	else:
		print('wow', item)
