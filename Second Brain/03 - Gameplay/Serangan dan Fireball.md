---
title: Serangan dan Fireball
type: concept
project: Petapa Agung
tags:
  - godot
  - gameplay
  - combat
  - projectile
---
# Serangan dan Fireball

## Serangan dekat
Player dan slime memiliki `AttackBox` yang diaktifkan ketika animasi serang mencapai frame tertentu. Area lawan menerima event dan memanggil fungsi damage. Player mendapat invulnerability singkat dan timer regen setelah terkena hit; musuh memperbarui indikator darah.

## Sihir
State `sihir.gd` menginstansiasi `fire_ball.tscn`, mengatur arah berdasarkan `arah_terakhir`, memberi referensi penembak, memutar sprite, dan menambahkan proyektil ke scene utama agar tidak ikut menjadi child player.

`fire_ball.gd` bergerak sesuai arah, mengabaikan penembak dan grup tertentu, lalu memanggil `kena_serang(attack_box)` pada target jika tersedia. Proyektil meledak dan dihapus setelah mengenai target atau umur maksimum tercapai.

Relasi: [[03 - Gameplay/Player|Player]], [[03 - Gameplay/AI Slime|AI Slime]], [[01 - Peta Proyek/Alur Game|Alur Game]].
