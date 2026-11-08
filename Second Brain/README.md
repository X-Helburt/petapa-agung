# Petapa Agung — Catatan Proyek Godot

> Catatan ini dibuat dari pembacaan berkas proyek Proyek tidak dijalankan atau dibuild saat catatan ini dibuat.

## Ringkasan

Petapa Agung adalah proyek game 2D berbasis Godot 4.7. Gameplay utamanya ditulis dengan GDScript. Pemain bergerak, menyerang jarak dekat, memakai sihir berupa fireball, menerima damage, mati, lalu respawn. Slime memiliki AI sederhana untuk mendeteksi dan mengejar pemain, menyerang saat dekat, mati, lalu respawn. Ada integrasi C++ melalui framework Jenova, tetapi skrip C++ yang ditemukan tampak masih berupa pekerjaan awal.

## Struktur folder

| Lokasi                  | Isi dan fungsi                                                                                           |
| ----------------------- | -------------------------------------------------------------------------------------------------------- |
| `project.godot`         | Pengaturan proyek, scene awal, input, renderer, dan physics.                                             |
| `scene/`                | Scene utama dunia, player, musuh, proyektil, dan UI.                                                     |
| `scripe/`               | Skrip gameplay [[GDScript]] serta sumber [[C++]] Jenova. Nama folder `scripe` memang demikian di proyek. |
| `sprites/`              | Aset visual seperti tileset dan sprite.                                                                  |
| `addons/limboai/`       | Plugin LimboAI; dari berkas gameplay yang ditinjau, belum terlihat dipakai oleh AI game.                 |
| `Jenova/`               | SDK Godot untuk C++, paket compiler, dan runtime Jenova.                                                 |
| `.jenova/`              | Data build/runtime dan artefak hasil build Jenova.                                                       |
| `Jenova.Module.vcxproj` | Konfigurasi build modul C++ Jenova di Visual Studio/MSBuild.                                             |

## Pengaturan dan titik masuk

Di `project.godot`, nama proyek adalah `petapa agung`, fitur engine menyebut Godot `4.7`, dan scene awal mengarah ke `scene/UI/ui_loby.tscn`. Input yang didefinisikan meliputi `atas`, `bawah`, `kiri`, `kanan`, `tombol_serang`, `tombol_sihir`, `tombol_panah`, dan `pause`. Gerak memakai WASD/panah; serang di P, sihir di O, panah di I, dan pause di Escape/Space.

Alur layar: lobi (`scene/UI/ui_loby.tscn`) → tombol mulai atau input pause → `scene/ggn.tscn` sebagai dunia permainan. Menu pause memiliki tombol kembali yang belum diimplementasikan dan tombol kembali ke lobi.

## Scene utama

- `scene/ggn.tscn`: dunia `Dunia`, TileMapLayer `tanah`, serta scene karakter dan musuh.
- `scene/player/player.tscn`: karakter pemain beserta sprite, collision, attack box, hurtbox, UI darah/mana, dan timer regenerasi.
- `scene/enemy/slime.tscn`: slime dengan sprite, hitbox, attack box, area deteksi, darah, dan timer.
- `scene/enemy/tengkorang.tscn`: musuh tengkorak dengan skrip GDScript.
- `scene/enemy/org.tscn`: scene musuh org yang memasang skrip Jenova C++ `scripe/org.cpp`.
- `scene/player/projektile/fire_ball.tscn`: proyektil sihir dengan skrip `scripe/fire_ball.gd`.
- `scene/player/projektile/panah.tscn`: scene panah; perilaku skripnya tidak termasuk alur yang dibaca secara rinci.
- `scene/UI/pause_menu.tscn` dan `scene/UI/ui_loby.tscn`: antarmuka lobi dan pause.

## Arsitektur skrip pemain Menggukanan [[GDScript]]

` scripe/player.gd` (tanpa spasi awal pada nama file: `scripe/player.gd`) menjadi pengendali pemain. Saat `_ready()`, skrip memuat state dan memberi setiap state referensi ke node player. State aktif disimpan di `state`, sedangkan kumpulan state disimpan di kamus `states`. Perpindahan dilakukan lewat `ubah_state()`, yang memanggil `exit()` state lama lalu `enter()` state baru.

State pemain:

| State            | Peran                                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------------- |
| `IdleState.gd`   | Memilih animasi idle dari arah terakhir dan membaca input untuk bergerak, serang, sihir, atau pause.    |
| `JalanState.gd`  | Membaca arah, mengatur kecepatan dan animasi gerak, lalu kembali idle ketika input berhenti.            |
| `SerangState.gd` | Memilih animasi serang berdasarkan arah; serangan berakhir melalui `animation_finished`.                |
| `sihir.gd`       | Membuat fireball, mengatur arah dan rotasi, menambahkannya ke scene utama, lalu kembali ke idle.        |
| `MatiState.gd`   | Mematikan kontrol/hitbox, memainkan animasi mati, menyembunyikan pemain sesaat, lalu memanggil respawn. |
| `State.gd`       | Kelas dasar dengan hook `enter`, `exit`, `handle_input`, `update`, dan `physics_update`.                |
| `PauseMenu.gd`   | State UX yang dimuat oleh player                                                                        |
| `inventory.gd`   | implementasinya belum ditinjau mendalam.                                                                |

Serangan jarak dekat mengaktifkan `AttackBox` saat animasi serangan mencapai frame 1 melalui `frame_changed`. Hurtbox pemain menerima area musuh dan mengambil nilai damage dari node penyerang. Darah diregenerasi menggunakan Timer setelah jeda.

## AI dan alur slime

`slime.gd` mengelola state slime, nyawa, kebal sesaat, respawn, dan drop sederhana. `area_slime_deteksi.gd` mengabarkan saat player masuk/keluar area deteksi. Ketika terdeteksi, slime menyimpan `target_player` dan beralih ke state jalan. `slimeJalan.gd` mengejar target dan beralih menyerang saat jarak cukup dekat. `slimeSerang.gd` memainkan animasi serangan; setelah animasi selesai, slime kembali mengejar atau idle. Ketika darah habis, `slimeMati.gd` memulai proses mati, menyembunyikan slime, lalu respawn di sel TileMap yang dipilih secara acak.

State machine slime adalah implementasi GDScript sendiri (`slimeStates.gd` menjadi kelas dasar). Plugin LimboAI berada di `addons/limboai`, tetapi belum terlihat menjadi bagian dari rangkaian ini.

## Serangan dan proyektil

`fire_ball.gd` menggerakkan proyektil pada arah yang diberikan, menghapusnya setelah umur maksimum, dan saat mengenai area target memanggil `kena_serang(attack_box)` bila tersedia. Proyektil menghindari penembak, player, dan grup `projektile`. Sihir dibuat oleh state `sihir.gd` dengan nilai arah terakhir pemain.

## [[Jenova]] dan [[C++]]

Jenova adalah jembatan framework untuk menjalankan skrip C++ sebagai modul Godot, dengan SDK yang menyediakan akses ke tipe/API Godot serta layanan runtime seperti callback lifecycle dan hot reload.

Konfigurasi yang dibaca:

- `Jenova.Module.vcxproj` menyetel output DLL di `.jenova`, menggunakan C++20, include Jenova SDK dan Godot SDK, serta mendaftarkan `scripe/org.cpp` dan `scripe/C++ Trees Limbo/tress_healt.cpp` untuk kompilasi.
- Target MSBuild memanggil `Jenova.Runtime.Win64.dll` untuk persiapan, membuat skrip internal, preprocess file C++, mengompilasi loader/modul, dan melakukan finalize.
- `Jenova/Jenova.Runtime.Packages.json` mencatat paket MSVC Bridge, Godot SDK 4.7, dan toolchain MinGW/LLVM.
- `Jenova/JenovaSDK/JenovaSDK.h` berisi macro dan API Jenova untuk wrapper fungsi, akses node, callback runtime, reload, dan utilitas lain.
- `.jenova/Jenova.Build.json` menunjukkan modul/proxy yang pernah dibentuk. `.jenova` juga berisi artefak build; ini bukan sumber utama gameplay.

Skrip C++ yang diperiksa belum menunjukkan implementasi gameplay lengkap. `tress_healt.cpp` masih template lifecycle kosong. `org.cpp` mendeklarasikan status dasar dan mengambil referensi node di `OnReady`, tetapi terdapat nama seperti `animated`, `attack_box`, dan `collision` yang dipakai tanpa deklarasi terlihat di file tersebut. Karena proyek tidak dibuild, status kompilasinya belum diverifikasi.

## Catatan teknis dari pembacaan

1. Nilai `KECEPATAN` pemain di `player.gd` adalah `17891`, lalu `JalanState.gd` mengalikan velocity dengan `delta` sebelum `move_and_slide()`. Pada pola CharacterBody2D Godot, velocity umumnya dinyatakan dalam piksel per detik dan tidak dikalikan delta sebelum `move_and_slide`; ini patut diverifikasi karena dapat menghasilkan gerak tidak sesuai.
2. Damage pemain dihitung sebagai `damage_diterima / tameng`. Keduanya integer, dan `tameng` bernilai 2; pembagian bilangan bulat dapat membuat damage kecil menjadi nol. Variabel `darah_tameng` juga berbeda dari `tameng`, jadi maksud mekanik perisainya patut diperiksa.
3. Nilai speed fireball `18790` dan kecepatan player `17891` tampak sangat besar dibanding speed slime `154.78`; periksa konsistensi satuan/skalanya.
4. Scene dan kode menunjukkan beberapa fitur masih berupa kerangka (misalnya tombol kembali pada pause menu, drop item berbasis `print`, dan sumber C++ yang belum lengkap).
5. Saya membaca sumber dan konfigurasi secara statis. Belum ada verifikasi runtime, build, atau uji input.

## Berkas yang menjadi rujukan

- `project.godot`
- `scene/ggn.tscn`
- `scene/player/player.tscn`
- `scene/enemy/slime.tscn`
- `scene/enemy/org.tscn`
- `scripe/player.gd` dan `scripe/states player/*.gd`
- `scripe/slime.gd` dan `scripe/state slime/*.gd`
- `scripe/fire_ball.gd`
- `Jenova.Module.vcxproj`
- `Jenova/Jenova.Runtime.Packages.json`
- `Jenova/JenovaSDK/JenovaSDK.h`
- `addons/limboai/README.md`
