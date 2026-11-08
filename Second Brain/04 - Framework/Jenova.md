---
title: Framework Jenova
type: technology
project: Petapa Agung
tags: [godot, cpp, jenova, framework]
---
# Framework Jenova

Jenova menyediakan jalur untuk menulis skrip C++ yang terhubung ke Godot melalui SDK/runtime framework. `JenovaSDK.h` mendefinisikan macro, wrapper API, akses node, callback runtime, reload, dan utilitas lain.

## Build proyek
`Jenova.Module.vcxproj` mendaftarkan `scripe/org.cpp` dan `scripe/C++ Trees Limbo/tress_healt.cpp`, menggunakan C++20 dan include Jenova SDK/Godot SDK. Target MSBuild memanggil `Jenova.Runtime.Win64.dll` untuk prepare, membuat skrip internal, preprocess sumber, kompilasi DLL, membuat watchdog, dan finalize. Konfigurasi paket berada di `Jenova/Jenova.Runtime.Packages.json`; artefak di `.jenova/`.

## Status yang dibaca
Kedua sumber C++ terdaftar dalam build. `tress_healt.cpp` tampak template lifecycle kosong. `org.cpp` masih terlihat sebagai implementasi awal, dan ada identifier node yang penggunaannya perlu diperiksa. Build belum diverifikasi.

Gameplay utama yang ditinjau berada di GDScript: [[03 - Gameplay/Player|Player]] dan [[03 - Gameplay/AI Slime|AI slime]]. Lihat [[05 - Referensi/Temuan dan Hal yang Perlu Dicek|temuan teknis]].
