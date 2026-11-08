---
title: Struktur Godot
type: concept
project: Petapa Agung
tags: [godot, scene, architecture]
---
# Struktur Godot

## Pengaturan proyek
`project.godot` menyebut Godot 4.7, renderer GL Compatibility, Jolt sebagai physics engine 3D, grup global `player`, `musuh`, `projektile`, dan input WASD/panah. Scene awal adalah lobi.

## Folder
- `scene/`: scene dunia, player, musuh, proyektil, UI.
- `scripe/`: skrip GDScript dan C++.
- `sprites/`: aset grafis.
- `addons/limboai/`: plugin AI.
- `Jenova/`: SDK, runtime, dan paket compiler.
- `.jenova/`: konfigurasi/artefak runtime build.

## Scene penting
`scene/ggn.tscn` adalah dunia utama dengan TileMap `tanah` dan instance karakter. Player punya AnimatedSprite2D, collision, `AttackBox`, hurtbox, darah, mana, dan timer. Slime punya hitbox, attack box, area deteksi, darah, dan timer.

Alur scene: [[01 - Peta Proyek/Alur Game|Alur Game]]. Logika karakter: [[03 - Gameplay/Player|Player]] dan [[03 - Gameplay/AI Slime|AI Slime]].
