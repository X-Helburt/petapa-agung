/* Jenova C++ Node Base Script (Meteora) */

#include <Godot/godot.hpp>
#include <Godot/classes/character_body2d.hpp>
#include <Godot/classes/animated_sprite2d.hpp>
#include <Godot/classes/area2d.hpp>
#include <Godot/classes/collision_shape2d.hpp>
#include <Godot/classes/texture_progress_bar.hpp>
#include <Godot/variant/variant.hpp>

using namespace godot;
using namespace jenova::sdk;

static CharacterBody2D* self = nullptr;

JENOVA_SCRIPT_BEGIN

int MAX_DARAH = 27;
float SPEED = 154.78f;
int damage_org = 5;
int darah_org = MAX_DARAH;
bool kebal = false;
bool sudah_mati = false;
double waktu_kebal = 0.0;

AnimatedSprite2D* animated = nullptr;
Area2D* hitbox = nullptr;
Area2D* attack_box = nullptr;
CollisionShape2D* attack_shape = nullptr;
CollisionShape2D* collision = nullptr;
TextureProgressBar* bar_darah = nullptr;

void OnAwake(Caller* instance) { self = GetSelf<CharacterBody2D>(instance); }

void OnDestroy(Caller* instance)
{
	self = nullptr;
	animated = nullptr;
	hitbox = nullptr;
	attack_box = nullptr;
	attack_shape = nullptr;
	collision = nullptr;
	bar_darah = nullptr;
}

void OnReady(Caller* instance)
{
	if (!self) self = GetSelf<CharacterBody2D>(instance);
	animated = self->get_node<AnimatedSprite2D>("AnimatedSprite2D");
	hitbox = self->get_node<Area2D>("Hitbox");
	attack_box = self->get_node<Area2D>("AttackBox");
	attack_shape = self->get_node<CollisionShape2D>("AttackBox/CollisionShape2D");
	collision = self->get_node<CollisionShape2D>("Hitbox/CollisionShape2D");
	bar_darah = self->get_node<TextureProgressBar>("darah");

	darah_org = MAX_DARAH;
	kebal = false;
	sudah_mati = false;
	waktu_kebal = 0.0;
	bar_darah->set_max(MAX_DARAH);
	bar_darah->set_value(darah_org);
	bar_darah->hide();
	attack_box->set_monitoring(true);
	attack_box->set_monitorable(true);
	attack_shape->set_disabled(false);
}

void OnProcess(Caller* instance, double delta)
{
	if (!self || sudah_mati) return;
	if (waktu_kebal > 0.0) {
		waktu_kebal -= delta;
		if (waktu_kebal <= 0.0) {
			kebal = false;
			if (animated) animated->set_modulate(Color(1, 1, 1, 1));
		}
	}

	// Hurtbox orc menerima AttackBox milik player.
	if (hitbox) {
		UtilityFunctions::print('kena')
		TypedArray<Area2D> serangan_masuk = hitbox->get_overlapping_areas();
		for (int64_t i = 0; i < serangan_masuk.size(); ++i) {
			Area2D* area = Object::cast_to<Area2D>(serangan_masuk[i]);
			if (!area || area->get_name() != StringName("AttackBox")) continue;
			Node* penyerang = area->get_parent();
			if (!penyerang || penyerang == self || penyerang->is_in_group("musuh")) continue;
			if (!area->is_monitoring() && !area->is_monitorable()) continue;
			if (kebal) break;

			int damage = 1;
			Variant damage_player = penyerang->get("damage_player");
			if (damage_player.get_type() == Variant::INT) damage = static_cast<int>(damage_player);
			darah_org -= MAX(1, damage);
			if (darah_org <= 0) {
				darah_org = 0;
				bar_darah->set_value(darah_org);
				bar_darah->show();
				sudah_mati = true;
				attack_box->set_deferred("monitoring", false);
				attack_shape->set_deferred("disabled", true);
				collision->set_deferred("disabled", true);
				self->set_physics_process(false);
				self->hide();
				break;
			}
			bar_darah->set_value(darah_org);
			bar_darah->show();
			kebal = true;
			waktu_kebal = 0.25;
			if (animated) animated->set_modulate(Color(1.8, 0.4, 0.4, 1));
			break;
		}
	}

	// AttackBox terus aktif; hurtbox player menerima area ini melalui signal area_entered.
}

JENOVA_SCRIPT_END
