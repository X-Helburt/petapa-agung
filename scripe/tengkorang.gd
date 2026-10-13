extends CharacterBody2D
@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox
@onready var collision := $CollisionShape2D
@onready var label_hp : Label = $Darah
@onready var regen: Timer = $regen


const MAX_DARAH: int = 25
const SPEED: float = 300.0 

var darah = MAX_DARAH
var sudah_mati = false
var kebal = false
var regen_tengkorak := 3




func _ready():
	hitbox.area_entered.connect(kena_serang)
	
	
	
#terkena serang
func kena_serang(area):
	if sudah_mati or kebal:
		return
	if area.name == "AttackBox" and (area.monitoring or area.monitorable):
		var player_node = area.get_parent()
		var damage_diterima = 1
		if player_node and "damage_player" in player_node:
			damage_diterima = player_node.damage_player
		# darah slime
		darah -= damage_diterima
		if darah <= 0:
			label_hp.hide()
			musuh_mati()
		else:
			# Efek visual kedip merah saat terkena serangan
			kebal = true
			sprite.modulate = Color(1.8, 0.4, 0.4)
			label_hp.show()
			regen.start(2)
			label_hp.text = str(darah)
			await get_tree().create_timer(0.2).timeout
			sprite.modulate = Color.WHITE
			kebal = false

func musuh_mati():
	sudah_mati = true
	hitbox.set_deferred("monitoring", false)
	set_physics_process(false)
	set_process(false)
	
	if sprite.sprite_frames:
		sprite.sprite_frames.set_animation_loop("tengkorak idle", false)
	
	sprite.play()
	await sprite.animation_finished
	
	collision.set_deferred("disabled", true)
	hide()
	await get_tree().create_timer(2.5).timeout
	show()
	respawn()

func respawn():
	sudah_mati = false
	kebal = false
	darah = MAX_DARAH
	sprite.modulate = Color.WHITE
	sprite.play()
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

# regenerasi
func _on_regen_timeout() -> void:
	
	if darah < MAX_DARAH:
		darah += regen_tengkorak
		label_hp.text = str(darah)
		
# drop item
func drop_tengkorak() -> void:
	var loot = randf()
	if loot <= 0.6:
		var item = randi_range(0, 10)
		print('ok', item)
	else:
		print('wow')
	pass
