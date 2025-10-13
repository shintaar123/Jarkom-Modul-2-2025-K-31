#!/bin/bash
# ============================
# SOAL 6 - Konfigurasi DNS Master & Slave
# ============================

echo "[1] Konfigurasi Master (Tirion/ns1)..."

# Buat direktori zone jika belum ada
mkdir -p /etc/bind/zones

# Tambahkan konfigurasi zona ke named.conf.local
cat > /etc/bind/named.conf.local << EOF
zone "k31.com" {
    type master;
    file "/etc/bind/zones/db.k31.com";
    notify yes;
    allow-transfer { 10.79.3.4; }; // Valmar (ns2)
};
EOF

# Buat file zona utama (db.k31.com)
cat > /etc/bind/zones/db.k31.com << EOF
\$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101101 ; Serial
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        30 )       ; Negative Cache TTL
;
@   IN  NS  ns1.k31.com.
@   IN  NS  ns2.k31.com.
ns1 IN  A   10.79.3.3
ns2 IN  A   10.79.3.4
EOF

# Validasi konfigurasi bind
named-checkconf
named-checkzone k31.com /etc/bind/zones/db.k31.com

# Restart bind9 secara manual
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo "[2] Konfigurasi Slave (Valmar/ns2)..."

# Tambahkan konfigurasi zona slave
cat > /etc/bind/named.conf.local << EOF
zone "k31.com" {
    type slave;
    file "/var/cache/bind/db.k31.com";
    masters { 10.79.3.3; }; // Tirion (Master)
};
EOF

# Jalankan ulang bind9 di Slave
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo "[3] Cek hasil zone transfer di Valmar..."
echo "Pastikan file db.k31.com muncul di /var/cache/bind/"
echo "Jika tampil simbol acak = normal (format biner)"

echo "[4] Bandingkan Serial SOA:"
echo "Di Master: dig @10.79.3.3 k31.com SOA"
echo "Di Slave : dig @10.79.3.4 k31.com SOA"
echo "Serial harus sama di keduanya -> zone transfer berhasil ✅"

echo "[5] (Opsional) Uji Transfer Otomatis:"
echo "Tambahkan 'test IN A 10.79.3.10' ke db.k31.com di Master,"
echo "naikkan serial jadi 2025101201, lalu restart bind:"
echo "/usr/sbin/named -c /etc/bind/named.conf -f -u bind &"
echo "Cek di Slave dengan: dig @10.79.3.4 test.k31.com"
