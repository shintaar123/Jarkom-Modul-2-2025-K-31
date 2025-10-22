#!/bin/bash
#
# Skrip Pengerjaan Soal 19 - Bagian DNS (havens -> www)
#
# !! JALANKAN INI DI SERVER MASTER DNS (TIRION) !!
#
# Skrip ini akan:
# 1. Menaikkan nomor Serial SOA secara otomatis.
# 2. Menambahkan CNAME record (havens IN CNAME www).
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

echo "[Soal 19 - DNS] Memulai modifikasi $ZONE_FILE..."

# --- 1. Menaikkan Serial SOA ---
CURRENT_SERIAL=$(grep ';\s*Serial' "$ZONE_FILE" | awk '{print $1}')
if [ -z "$CURRENT_SERIAL" ]; then
    echo "Error: Tidak dapat menemukan Serial SOA di $ZONE_FILE."
    exit 1
fi
NEW_SERIAL=$((CURRENT_SERIAL + 1))

echo "[Soal 19 - DNS] Menaikkan Serial SOA dari $CURRENT_SERIAL -> $NEW_SERIAL..."
sed -i "s/$CURRENT_SERIAL/$NEW_SERIAL/" "$ZONE_FILE"

# --- 2. Menambahkan Record DNS Baru ---
echo "[Soal 19 - DNS] Menambahkan CNAME 'havens'..."
# Gunakan 'cat' dan 'EOF' untuk menambahkan di akhir file
cat >> "$ZONE_FILE" <<'EOF'

; --- TAMBAHAN UNTUK SOAL 19 ---
havens   IN  CNAME   www
EOF

# --- 3. Validasi & Restart BIND9 ---
echo "[Soal 19 - DNS] Memvalidasi file zona..."
named-checkzone k31.com "$ZONE_FILE"

echo "[Soal 19 - DNS] Merestart BIND9 (named)..."
pkill named || true
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 19 (DNS) Selesai di Tirion."
echo " JANGAN LUPA JALANKAN SKRIP NGINX DI SIRION!"
echo "--------------------------------------------------------"
echo ""




#!/bin/bash
#
# Skrip Pengerjaan Soal 19 - Bagian Nginx (Memperbaiki 301)
#
# !! JALANKAN INI DI SERVER REVERSE PROXY (SIRION) !!
#
# Skrip ini akan mengedit 'reverse-proxy.conf' agar Nginx
# menerima 'havens.k31.com' sebagai hostname kanonik.
#

# Hentikan skrip jika ada perintah yang gagal
set -e

CONFIG_FILE="/etc/nginx/sites-available/reverse-proxy.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: File konfigurasi $CONFIG_FILE tidak ditemukan!"
    echo "Pastikan Anda menjalankan ini di node Sirion."
    exit 1
fi

# Baris yang kita cari (dari Soal 13)
OLD_LINE="server_name www.k31.com;"
# Baris baru
NEW_LINE="server_name www.k31.com havens.k31.com;"

echo "[Soal 19 - Nginx] Memodifikasi $CONFIG_FILE..."

# Cek apakah sudah diubah
if grep -q "$NEW_LINE" "$CONFIG_FILE"; then
    echo "[Soal 19 - Nginx] Konfigurasi 'havens.k31.com' sudah ada."
else
    # Ganti baris lama dengan baris baru
    sed -i "s/$OLD_LINE/$NEW_LINE/" "$CONFIG_FILE"
    echo "[Soal 19 - Nginx] Berhasil menambahkan 'havens.k31.com' ke server_name."
fi

# --- 3. Tes dan Restart Nginx ---
echo "[Soal 19 - Nginx] Mengetes sintaks konfigurasi Nginx..."
nginx -t
# Jika 'nginx -t' gagal, 'set -e' akan menghentikan skrip di sini

echo "[Soal 19 - Nginx] Merestart layanan Nginx..."
service nginx restart

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 19 (Nginx) Selesai di Sirion."
echo "--------------------------------------------------------"
echo "Sekarang Anda bisa melakukan verifikasi dari Earendil/Elrond:"
echo "  dig havens.k31.com"
echo "  curl http://havens.k31.com/app/"
echo ""
