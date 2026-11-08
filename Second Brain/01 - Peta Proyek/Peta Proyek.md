---
title: Peta Proyek
type: map
project: Petapa Agung
tags:
  - godot
  - architecture
  - moc
---
# Peta Proyek

## Arsitektur singkat
Petapa Agung adalah game 2D Godot 4.7. Scene menyusun objek dan aset; GDScript mengendalikan gameplay; Jenova menyediakan jalur integrasi C++ melalui modul native. [[02 - Godot dan Scene/Struktur Godot|Struktur Godot]]

## Hubungan konsep
- Boot → [[02 - Godot dan Scene/Struktur Godot|project.godot]] → [[01 - Peta Proyek/Alur Game|lobi → dunia]].
- [[03 - Gameplay/Player|Player]] menjalankan [[03 - Gameplay/State Machine Pemain|state machine pemain]].
- [[03 - Gameplay/AI Slime|Slime]] mendeteksi dan mengejar player lewat area deteksi dan state sendiri.
- [[03 - Gameplay/Serangan dan Fireball|AttackBox dan fireball]] menghubungkan serangan dengan sistem damage.
- [[04 - Framework/Jenova|Jenova]] mengompilasi skrip C++ yang didaftarkan oleh project build.
- [[04 - Framework/LimboAI|LimboAI]] tersedia sebagai addon, namun belum tampak dipakai oleh AI gameplay yang ditinjau.

## Sumber utama
| Konsep | Berkas sumber |
|---|---|
| Konfigurasi dan input | `project.godot` |
| Dunia | `scene/ggn.tscn` |
| Player | `scripe/player.gd`, `scene/player/player.tscn` |
| State player | `scripe/states player/*.gd` |
| Slime | `scripe/slime.gd`, `scripe/state slime/*.gd`, `scene/enemy/slime.tscn` |
| Fireball | `scripe/fire_ball.gd`, `scripe/states player/sihir.gd` |
| Jenova build | `Jenova.Module.vcxproj`, `Jenova/JenovaSDK/JenovaSDK.h` |

Lihat juga [[01 - Peta Proyek/Alur Game|Alur Game]] dan [[05 - Referensi/Temuan dan Hal yang Perlu Dicek|Temuan teknis]].
