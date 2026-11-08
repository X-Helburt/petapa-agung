---
title: AI Slime
type: component
project: Petapa Agung
tags:
  - godot
  - gameplay
  - ai
  - slime
source: scripe/slime.gd
---
# AI Slime

AI slime adalah finite state machine buatan proyek dengan kelas dasar `slimeStates.gd`; bukan Behavior Tree LimboAI.

## Deteksi dan transisi
Dalam `area_slime_deteksi.gd` menerima body masuk/keluar, dan memanggil `on_player_terdeteksi()` atau `on_player_hilang()`. Slime menyimpan target. State jalan mengukur jarak, bergerak ke player, dan beralih ke serang saat dekat. State serang memainkan animasi non-loop; setelah selesai, slime mengejar lagi jika target masih ada, atau kembali idle.

## Mati dan respawn
Saat darah habis, state mati memanggil `musuh_mati()`. Slime mematikan proses/hitbox, memainkan animasi, bersembunyi, melakukan drop sederhana, kemudian mencari sel TileMap acak dan mengaktifkan kembali collision serta state idle.

Terkait: [[03 - Gameplay/Serangan dan Fireball|Sistem damage]], [[04 - Framework/LimboAI|LimboAI]], [[01 - Peta Proyek/Alur Game|Alur Game]].
