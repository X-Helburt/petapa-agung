---
title: LimboAI
type: technology
project: Petapa Agung
tags: [godot, ai, limboai, plugin]
---
# LimboAI

LimboAI adalah addon Godot untuk Behavior Tree dan Hierarchical State Machine. README addon pada proyek menyebut dukungan Godot 4.6+ untuk jalur GDExtension dan Godot 4.7 untuk modul.

Plugin berada di `addons/limboai/`. Dalam scene dan skrip gameplay yang ditinjau, AI slime memakai state machine GDScript proyek sendiri; tidak tampak node/task LimboAI yang terhubung. Artinya keberadaan addon tidak dengan sendirinya berarti AI proyek menggunakannya.

Lihat implementasi yang ada: [[03 - Gameplay/AI Slime|AI Slime]].
