#!/bin/bash
# ============================
# SOAL 8 - Reverse DNS (PTR Record)
# ============================

# ------------------------------------------
# Bagian 1: Konfigurasi Master (Tirion)
# ------------------------------------------

echo "[1] Konfigurasi Reverse Zone di Tirion (Master DNS)..."

# Tambahkan konfigurasi zona reverse ke named.conf.local
cat >> /etc/bind/named.conf.local <<'EOF'

zone "3.79.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.79.3";
    notify yes;
    allow-transfer { 10.79.3.4; };  // Valmar (ns2)
};
EOF

# Buat file zona reverse baru
mkdir -p /etc/bind/zones
cat > /etc/bind/zones/db.10.79.3 <<'EOF'
$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101201 ; Serial - naikkan tiap perubahan
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        30         ; Minimum TTL
)
        IN  NS  ns1.k31.com.
        IN  NS  ns2.k31.com.

; PTR records for DMZ 10.79.3.0/24
2       IN  PTR sirion.k31.com.
5       IN  PTR lindon.k31.com.
6       IN  PTR vingilot.k31.com.
EOF

# Validasi zona dan konfigurasi BIND
named-checkzone 3.79.10.in-addr.arpa /etc/bind/zones/db.10.79.3
named-checkconf

# Restart Bind9
pkill named || true
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo "[✅] Reverse zone di Tirion selesai dikonfigurasi dan dijalankan."

# Verifikasi PTR di Master
echo "[2] Uji PTR Record dari Tirion:"
dig @10.79.3.3 -x 10.79.3.2 +short   # sirion.k31.com.
dig @10.79.3.3 -x 10.79.3.5 +short   # lindon.k31.com.
dig @10.79.3.3 -x 10.79.3.6 +short   # vingilot.k31.com.

# ------------------------------------------
# Bagian 2: Konfigurasi Slave (Valmar)
# ------------------------------------------

echo "[3] Konfigurasi Reverse Zone di Valmar (Slave DNS)..."

cat >> /etc/bind/named.conf.local <<'EOF'

zone "3.79.10.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.10.79.3";
    masters { 10.79.3.3; };  // Tirion (master)
};
EOF

# Restart Bind9 di Valmar
pkill named || true
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

# Cek apakah file transfer berhasil
echo "[4] Verifikasi file hasil transfer di Valmar:"
ls -l /var/cache/bind/ | grep db.10.79.3 || true

# Uji zone di Slave
echo "[5] Uji SOA dan PTR dari Valmar:"
dig @10.79.3.4 3.79.10.in-addr.arpa SOA
dig @10.79.3.4 -x 10.79.3.2
dig @10.79.3.4 -x 10.79.3.5
dig @10.79.3.4 -x 10.79.3.6

# ------------------------------------------
# Bagian 3: Tes dari Klien (Earendil & Elrond)
# ------------------------------------------

echo "[6] Uji dari klien (Earendil & Elrond)..."
echo "Di kedua node jalankan:"
echo "  dig -x 10.79.3.2"
echo "  dig -x 10.79.3.5"
echo "  dig -x 10.79.3.6"
echo ""
echo "Hasil seharusnya:"
echo "10.79.3.2 → sirion.k31.com."
echo "10.79.3.5 → lindon.k31.com."
echo "10.79.3.6 → vingilot.k31.com."

# ------------------------------------------
# Bagian 4: Validasi Serial Master & Slave
# ------------------------------------------

echo "[7] Bandingkan Serial SOA di Master & Slave..."
echo "  dig @10.79.3.3 3.79.10.in-addr.arpa SOA | grep SOA   # Master"
echo "  dig @10.79.3.4 3.79.10.in-addr.arpa SOA | grep SOA   # Slave"
echo "✅ Pastikan angka serial sama agar zone transfer sukses."

echo "[✅] Konfigurasi Reverse DNS selesai."
