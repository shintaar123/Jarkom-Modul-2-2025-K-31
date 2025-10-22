# Node: TIRION

# 1. Edit file zona
nano /etc/bind/zones/db.k31.com

#    --- DI DALAM NANO ---
#    Ubah $TTL di baris paling atas:
#    $TTL 30
#
#    Ubah Minimum TTL (angka terakhir di SOA):
#    ... (
#        ...
#        30         ; Minimum TTL
#    )
#
#    Naikkan Nomor Serial:
#    (misal: 2025101202 ; Serial)
#    --- SIMPAN DAN KELUAR ---

# 2. Cek sintaks dan restart BIND9
named-checkzone k31.com /etc/bind/zones/db.k31.com
pkill named || true
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo "Fase 1 Selesai. Lanjutkan ke Earendil."


# Node: EARENDIL

# 'Bilas' cache lama (jika ada) dan tunggu 30 detik
# agar cache lama benar-benar kedaluwarsa
echo "Membilas cache DNS lama..."
dig static.k31.com > /dev/null
sleep 30
echo "Cache lama bersih. Siap untuk Momen 1."



# Node: EARENDIL
echo "--- Momen 1: Query IP LAMA (Cache 30 detik dimulai) ---"
dig static.k31.com



# Node: TIRION
echo "--- Fase 2: Mengubah IP Lindon ke 10.79.3.50 ---"

# 1. Edit file zona LAGI
nano /etc/bind/zones/db.k31.com

#    --- DI DALAM NANO ---
#    Ubah A Record Lindon:
#    lindon   IN  A   10.79.3.50
#
#    Naikkan Nomor Serial LAGI:
#    (misal: 2025101203 ; Serial)
#    --- SIMPAN DAN KELUAR ---

# 2. Cek sintaks dan restart BIND9
named-checkzone k31.com /etc/bind/zones/db.k31.com
pkill named || true
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo "Perubahan IP di Master selesai. Cek Earendil SEKARANG."


# Node: EARENDIL
# (Jalankan ini SEBELUM 30 detik dari Momen 1 habis!)

echo "--- Momen 2: Query dari Cache (Harus IP LAMA) ---"
dig static.k31.com


# Node: EARENDIL

echo "--- Momen 3: Menunggu cache 30 detik kedaluwarsa... ---"
sleep 30

echo "--- Momen 3: Query IP BARU (Cache sudah habis) ---"
dig static.k31.com

# Node: VALMAR

echo "--- Verifikasi Slave: Cek sinkronisasi Valmar ---"
# Tanyakan ke server DNS lokal Valmar
dig @localhost static.k31.com
