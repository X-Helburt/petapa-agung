---
title: Temuan dan Hal yang Perlu Dicek
type: review-notes
project: Petapa Agung
tags: [godot, review, verification]
status: static-review-only
---
# Temuan dan Hal yang Perlu Dicek

> [!warning] Batasan
> Catatan ini berasal dari pembacaan statis. Tidak ada runtime test atau build dalam pemeriksaan ini; poin di bawah adalah hipotesis/hal yang perlu diverifikasi.

1. `player.gd` menetapkan `KECEPATAN = 17891`. `JalanState.gd` mengalikan velocity dengan `delta`, lalu player menjalankan `move_and_slide()`. Periksa skala kecepatan dan penggunaan delta pada velocity.
2. Damage pemain `damage_diterima / tameng` memakai nilai integer, dengan `tameng = 2`; pembagian integer berpotensi menghasilkan nol untuk damage kecil. Variabel `darah_tameng` terpisah dari `tameng`.
3. Kecepatan fireball `18790` tampak tidak sebanding dengan slime `154.78`; periksa satuan.
4. `org.cpp` memakai identifier `animated`, `attack_box`, dan `collision` tanpa deklarasi yang terlihat pada file yang dibaca. Verifikasi preprocessing/build Jenova.
5. Tombol kembali pada `pause_menu.gd` kosong; drop item masih berupa `print`.
6. `project.godot` menetapkan Jolt sebagai 3D physics engine sementara proyek tampak 2D; cek apakah konfigurasi tersebut disengaja.

Rujukan: [[03 - Gameplay/Player|Player]], [[03 - Gameplay/Serangan dan Fireball|Serangan]], [[04 - Framework/Jenova|Jenova]], [[02 - Godot dan Scene/Struktur Godot|Struktur Godot]].
