---
title: Alur Game
type: flow
project: Petapa Agung
tags: [godot, flow, gameplay]
---
# Alur Game

## Alur layar
`project.godot` menetapkan `scene/UI/ui_loby.tscn` sebagai scene awal. Tombol mulai atau input pause memuat `scene/ggn.tscn`. Scene pause menyediakan tombol kembali ke lobi; tombol kembali melanjutkan permainan masih kosong.

## Alur saat bermain
1. Scene dunia membuat TileMap dan karakter: [[02 - Godot dan Scene/Struktur Godot|struktur scene]].
2. Player menginisialisasi komponen dan state, lalu masuk ke idle: [[03 - Gameplay/Player|Player]].
3. Input memilih gerak, serangan, sihir, atau pause: [[03 - Gameplay/State Machine Pemain|State machine pemain]].
4. Serangan dekat membuka `AttackBox` pada frame animasi tertentu; sihir membuat proyektil: [[03 - Gameplay/Serangan dan Fireball|Serangan dan fireball]].
5. Slime mendeteksi player, mengejar, dan menyerang ketika jarak dekat: [[03 - Gameplay/AI Slime|AI slime]].
6. Damage mengurangi darah; kematian memulai animasi dan jeda sebelum respawn.

## Alur respawn
Player kembali ke posisi awal dan darah penuh. Slime mencoba memilih sel TileMap lain, mengaktifkan kembali collision/hitbox, lalu kembali idle. Detail dan hal yang perlu diverifikasi ada di [[05 - Referensi/Temuan dan Hal yang Perlu Dicek|temuan teknis]].
