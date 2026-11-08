---
title: State Machine Pemain
type: concept
project: Petapa Agung
tags: [godot, gameplay, state-machine]
---
# State Machine Pemain

Pola state machine memisahkan perilaku player berdasarkan mode. Kelas dasar `State.gd` mendefinisikan hook siklus hidup; player menyimpan instance dalam kamus dan mengatur transisi melalui `ubah_state()`.

## State
- `IdleState`: animasi diam dan memilih state dari input.
- `JalanState`: membaca empat arah, animasi, dan gerak.
- `SerangState`: animasi serang sesuai arah; kembali ke idle/jalan saat selesai.
- `sihir`: membuat fireball dan kembali idle.
- `MatiState`: mengunci kontrol, mematikan collision/hurtbox, animasi mati, respawn.
- `PauseMenu` dan `inventory`: state UX yang dimuat player.

Arah terakhir menjadi dasar animasi idle/serang dan arah fireball. Rincian kendali utama ada di [[03 - Gameplay/Player|Player]], sedangkan urutan dari input ke efek serang di [[01 - Peta Proyek/Alur Game|Alur Game]].
