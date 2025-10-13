#!/bin/bash
# ============================================
# Soal_3.sh
# Menambahkan resolver eksternal di semua host non-router
# ============================================

echo "=== Konfigurasi resolver eksternal ==="

# Menulis DNS resolver agar semua host bisa akses internet
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Tes koneksi internet
ping -c 2 google.com

echo "=== Konfigurasi resolver selesai! ==="
