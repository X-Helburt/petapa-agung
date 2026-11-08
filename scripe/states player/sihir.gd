extends State

const FIRE_BALL_SCENE: PackedScene = preload("res://scene/player/projektile/fire_ball.tscn")
const BIAYA_MANA: float = 5.5

var cast_menunggu_animasi: bool = false
var cooldown_tanpa_animasi: float = 0.0

func enter() -> void:
	if not player.gunakan_mana(BIAYA_MANA):
		player.ubah_state("idle")
		return

	var animasi: AnimatedSprite2D = player.get_animasi()
	if animasi and animasi.sprite_frames and animasi.sprite_frames.has_animation("sihir"):
		animasi.sprite_frames.set_animation_loop("sihir", false)
		animasi.play("sihir")
		cast_menunggu_animasi = true
	else:
		push_warning("Animasi 'sihir' belum ada pada AnimatedSprite2D player.")
		serang_fireball(player.arah_terakhir)
		cooldown_tanpa_animasi = 0.5

func exit() -> void:
	cast_menunggu_animasi = false
	cooldown_tanpa_animasi = 0.0

func update(_delta: float) -> void:
	if cooldown_tanpa_animasi > 0.0:
		cooldown_tanpa_animasi -= _delta
		if cooldown_tanpa_animasi <= 0.0 and player.state == self:
			player.ubah_state("idle")
		return
	if not cast_menunggu_animasi:
		return
	if not is_instance_valid(player) or player.sudah_mati_player or player.state != self:
		cast_menunggu_animasi = false
		return

	var animasi: AnimatedSprite2D = player.get_animasi()
	if animasi.animation != "sihir" or animasi.is_playing():
		return

	cast_menunggu_animasi = false
	serang_fireball(player.arah_terakhir)
	player.ubah_state("idle")

func serang_fireball(arah: Vector2) -> void:
	if arah == Vector2.ZERO:
		arah = Vector2.RIGHT
	arah = arah.normalized()

	var bola_api = FIRE_BALL_SCENE.instantiate()
	bola_api.arah_terbang = arah
	bola_api.penembak = player

	var sprite: AnimatedSprite2D = bola_api.get_node("AnimatedSprite2D")
	sprite.rotation_degrees = rad_to_deg(arah.angle()) + -90

	player.get_tree().current_scene.add_child(bola_api)
	bola_api.global_position = player.global_position
