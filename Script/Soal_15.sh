#!/bin/bash
#
# Skrip Pengerjaan Soal 15 - Uji Beban (ApacheBench)
#
# Skrip ini akan dijalankan di ELROND untuk:
# 1. Menginstal 'apache2-utils' (termasuk 'ab').
# 2. Menjalankan 2 tes 'ab' ke server www.k31.com.
#

# Hentikan skrip jika ada perintah yang gagal
set -e

echo "[Soal 15] Memulai skrip di Elrond..."

# --- 1. Perbaikan DNS Sementara & Instalasi ---
echo "[Soal 15] Mengkonfigurasi DNS eksternal sementara untuk instalasi..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo "[Soal 15] Menjalankan apt-get update..."
apt-get update > /dev/null

echo "[Soal 15] Menginstal apache2-utils (untuk 'ab')..."
apt-get install -y apache2-utils > /dev/null
echo "[Soal 15] 'ab' (apache2-utils) berhasil diinstal."

# --- 2. Mengembalikan Konfigurasi DNS Internal (WAJIB) ---
echo "[Soal 15] Mengembalikan DNS internal (Tirion/Valmar) agar bisa resolve 'k31.com'..."
echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

echo "[Soal 15] Konfigurasi DNS dikembalikan."
sleep 1 # Jeda singkat untuk memastikan file I/O selesai

# --- 3. Menjalankan Tes ApacheBench ---
echo ""
echo "--------------------------------------------------------"
echo " [ Tes 1/2 ] Menjalankan Uji Beban Dinamis: /app/"
echo " (Perintah: ab -n 500 -c 10 http://www.k31.com/app/)"
echo "--------------------------------------------------------"
ab -n 500 -c 10 http://www.k31.com/app/

echo ""
echo "--------------------------------------------------------"
echo " [ Tes 2/2 ] Menjalankan Uji Beban Statis: /static/"
echo " (Perintah: ab -n 500 -c 10 http://www.k31.com/static/)"
echo "--------------------------------------------------------"
ab -n 500 -c 10 http://www.k31.com/static/

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 15 Selesai."
echo "Ambil screenshot dari kedua hasil tes di atas."
echo "--------------------------------------------------------"
echo ""
