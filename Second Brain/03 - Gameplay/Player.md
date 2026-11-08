---
title: Player
type: component
project: Petapa Agung
tags: [godot, gameplay, player]
source: scripe/player.gd
---
# Player

`player.gd` memperluas `CharacterBody2D`; ia menyimpan darah, mana, armor, arah terakhir, invulnerability, referensi node, serta kamus state. `_ready()` memuat state, menghubungkan sinyal animasi/hurtbox/timer, mematikan attack box di awal, lalu memulai `idle`.

## Update loop
- `_input()` meneruskan input ke state.
- `_process()` memanggil `state.update()`.
- `_physics_process()` menjalankan `state.physics_update()` lalu `move_and_slide()`.
- `ubah_state()` menjalankan `exit()` state lama lalu `enter()` state baru.

## Komponen dan pertarungan
`AnimatedSprite2D` mengatur animasi; `AttackBox` menyerang; `hurtbox` menerima hit; `TextureProgressBar` menunjukkan darah; `Timer regen` memulihkan darah. Sinyal `frame_changed` mengaktifkan attack box pada frame 1 animasi serang.

Player mati jika darah habis, lalu [[03 - Gameplay/State Machine Pemain|MatiState]] mematikan collision/hurtbox, memainkan animasi, dan memanggil `respawn()`.

Terkait: [[03 - Gameplay/Serangan dan Fireball|Serangan]], [[01 - Peta Proyek/Alur Game|Alur Game]], [[05 - Referensi/Temuan dan Hal yang Perlu Dicek|Temuan teknis]].
