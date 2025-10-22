#!/bin/bash
#
# Skrip Pengerjaan Soal 18 - Menambahkan TXT & CNAME (Melkor)
#
# !! JALANKAN INI DI SERVER MASTER DNS (TIRION) !!
#
# Skrip ini akan:
# 1. Menaikkan nomor Serial SOA secara otomatis.
# 2. Menambahkan record TXT (melkor) dan CNAME (morgoth).
# 3. Merestart BIND9.
#

# Hentikan skrip jika ada perintah yang gagal
set -e

ZONE_FILE="/etc/bind/zones/db.k31.com"

if [ ! -f "$ZONE_FILE" ]; then
    echo "Error: File zona $ZONE_FILE tidak ditemukan!"
    echo "Pastikan Anda menjalankan ini di node Tirion."
    exit 1
fi

echo "[Soal 18] Memulai modifikasi $ZONE_FILE..."

# --- 1. Menaikkan Serial SOA ---
# Ambil serial saat ini (angka pertama di baris yang mengandung "; Serial")
CURRENT_SERIAL=$(grep ';\s*Serial' "$ZONE_FILE" | awk '{print $1}')

if [ -z "$CURRENT_SERIAL" ]; then
    echo "Error: Tidak dapat menemukan Serial SOA di $ZONE_FILE."
    exit 1
fi

# Tambah 1 ke serial
NEW_SERIAL=$((CURRENT_SERIAL + 1))

echo "[Soal 18] Menaikkan Serial SOA dari $CURRENT_SERIAL -> $NEW_SERIAL..."
# Ganti serial lama dengan yang baru di file
sed -i "s/$CURRENT_SERIAL/$NEW_SERIAL/" "$ZONE_FILE"

# --- 2. Menambahkan Record DNS Baru ---
echo "[Soal 18] Menambahkan record TXT (melkor) dan CNAME (morgoth)..."
# Gunakan 'cat' dan 'EOF' untuk menambahkan di akhir file
cat >> "$ZONE_FILE" <<'EOF'

; --- TAMBAHAN UNTUK SOAL 18 ---
melkor   IN  TXT     "Morgoth (Melkor)"
morgoth  IN  CNAME   melkor
EOF

# --- 3. Validasi & Restart BIND9 ---
echo "[Soal 18] Memvalidasi file zona..."
named-checkzone k31.com "$ZONE_FILE"
# (set -e akan menangkap error di sini jika validasi gagal)

echo "[Soal 18] Merestart BIND9 (named)..."
pkill named || true
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

# --- 4. (Opsional) Restart BIND9 di Valmar ---
# Skrip ini tidak bisa merestart Valmar, tapi ini pengingat
echo "[Soal 18] Mengirim notifikasi ke Valmar (jika 'notify yes' aktif)..."
# Jika ingin Valmar cepat update, restart manual di sana:
# pkill named || true; /usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 18 Selesai di Tirion."
echo "--------------------------------------------------------"
echo "Langkah selanjutnya: Pindah ke EARENDIL dan jalankan verifikasi:"
echo "  dig melkor.k31.com TXT"
echo "  dig morgoth.k31.com"
echo ""
