# Report Implementasi Mobile Ticketing

## Ringkasan
Project `mobile_ticketing` diimplementasikan sebagai prototipe frontend Flutter dengan seluruh data hardcoded/local state (tanpa backend API). Struktur dan nuansa visual mewarisi pola dari project `mobile`, lalu dipoles untuk konsistensi navigasi, layout, dan tema.

## Visual System

### Kategori Warna
- Primary accent: `#7C3AED` (aksi utama, seed color tema).
- Success: `#4ADE80`.
- Warning: `#FBBF24`.
- Error: `#F87171`.
- Light surface: background `#F8F8F8`, card putih, divider `#E5E7EB`.
- Dark surface: background `#0A0A0A`, card `#141414`, border `#252525`.

### Dashboard Gradients
- Ringkasan statistik memakai 4 gradien untuk pembedaan kategori ticket:
	1. Ungu (`#7C3AED` → `#9F67F5`)
	2. Biru (`#2563EB` → `#60A5FA`)
	3. Hijau (`#059669` → `#34D399`)
	4. Amber (`#D97706` → `#FBBF24`)

### Tipografi
- Font family menggunakan **Inter** via `google_fonts`.
- Penerapan konsisten pada text theme dan komponen AppBar/Button.

## Pendekatan Layout
- Konten utama dashboard dibatasi `maxContentWidth = 980` agar nyaman di layar lebar.
- Spacing diseragamkan dengan token konstanta (`paddingSmall/Medium/Large`, `sectionGap`).
- Card radius konsisten (`radiusLarge = 16`) sehingga tampilan antarlayar lebih seragam.

## Polishing Komponen
- Ditambahkan komponen `UniversalBackButton` sebagai fallback universal:
	- Jika ada stack: `pop`.
	- Jika tidak ada stack: kembali ke dashboard.
- `UniversalBackButton` dipasang pada layar non-root utama:
	- Tickets list/detail/create.
	- Notifications.
	- Profile.
	- Admin ticket management.
	- Register dan reset password.
- Navigasi internal dipoles ke pola stack-friendly (`push`) untuk transisi layar yang membutuhkan riwayat kembali.
- Pada create ticket, transisi ke detail memakai `pushReplacement` agar alur back lebih natural.

## Implementasi Fungsional
- Auth: login/register/reset/logout dengan repository mock + local persistence.
- Ticketing: list, infinite load hardcoded, create, detail, komentar, assign, update status.
- Notifikasi: feed notifikasi in-app, mark read per item/semua.
- Role guard: proteksi route berbasis role (user/helpdesk/admin).

## Catatan Data
- Seluruh data adalah data simulasi hardcoded/local store.
- Tidak ada integrasi API/backend/database server pada fase ini.

## Hasil Akhir
- UI lebih sejajar dengan bahasa visual project `mobile` (warna, densitas, tipografi, card style).
- Dashboard lebih rapi di desktop/mobile lewat pembatasan lebar konten dan grid responsif.
- Navigasi antarhalaman lebih konsisten dan mudah dipahami pengguna.
