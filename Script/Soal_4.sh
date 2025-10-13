#!/bin/bash
# ============================================
# Soal_4.sh
# Setup DNS Master (Tirion) & Slave (Valmar) untuk domain k31.com
# serta konfigurasi resolver di semua host non-router
# ============================================

echo "=== Memulai konfigurasi DNS di Tirion dan Valmar ==="

# ========================================================
# BAGIAN 1: KONFIGURASI DNS MASTER (TIRION)
# ========================================================
if [[ $(hostname) == "Tirion" ]]; then
    echo "=== Konfigurasi BIND9 di TIRION (Master) ==="
    apt update && apt install -y bind9

    mkdir -p /etc/bind/zones

    cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    dnssec-validation auto;
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

    cat <<EOF > /etc/bind/named.conf.local
zone "k31.com" {
    type master;
    file "/etc/bind/zones/db.k31.com";
    notify yes;
    allow-transfer { 10.79.3.4; }; // Valmar (ns2)
};
EOF

    cat <<EOF > /etc/bind/zones/db.k31.com
\$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101101 ; Serial
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        30         ; Minimum TTL
)
; --- NS Record ---
    IN  NS  ns1.k31.com.
    IN  NS  ns2.k31.com.

; --- A Record ---
ns1     IN  A   10.79.3.3      ; Tirion (master)
ns2     IN  A   10.79.3.4      ; Valmar (slave)
@       IN  A   10.79.3.2      ; Sirion (front door)

; --- Hostname Records ---
sirion  IN  A   10.79.3.2
lindon  IN  A   10.79.3.5
vingilot IN A   10.79.3.6

; --- CNAME (alias) ---
www     IN  CNAME sirion
static  IN  CNAME lindon
app     IN  CNAME vingilot
EOF

    # Validasi konfigurasi BIND
    named-checkconf
    named-checkzone k31.com /etc/bind/zones/db.k31.com

    # Jalankan BIND9 secara manual (foreground mode)
    /usr/sbin/named -c /etc/bind/named.conf -f -u bind &

    # Cek apakah service aktif
    ps aux | grep named
fi

# ========================================================
# BAGIAN 2: KONFIGURASI DNS SLAVE (VALMAR)
# ========================================================
if [[ $(hostname) == "Valmar" ]]; then
    echo "=== Konfigurasi BIND9 di VALMAR (Slave) ==="
    apt update && apt install -y bind9

    mkdir -p /var/cache/bind

    cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    dnssec-validation auto;
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

    cat <<EOF > /etc/bind/named.conf.local
zone "k31.com" {
    type slave;
    file "/var/cache/bind/db.k31.com";
    masters { 10.79.3.3; }; // Tirion (master)
};
EOF

    # Jalankan BIND9 di Valmar
    /usr/sbin/named -c /etc/bind/named.conf -f -u bind &

    # Cek apakah zone transfer berhasil
    sleep 3
    ls /var/cache/bind/
    dig @10.79.3.4 k31.com
fi

# ========================================================
# BAGIAN 3: KONFIGURASI RESOLVER DI SEMUA HOST NON-ROUTER
# ========================================================
if [[ $(hostname) != "Eonwe" ]]; then
    echo "=== Menambahkan resolver di semua host non-router ==="
    echo "nameserver 10.79.3.3" > /etc/resolv.conf   # Tirion (ns1)
    echo "nameserver 10.79.3.4" >> /etc/resolv.conf  # Valmar (ns2)
    echo "nameserver 192.168.122.1" >> /etc/resolv.conf
    cat /etc/resolv.conf

    # Tes query DNS
    dig k31.com
    dig ns1.k31.com
    dig sirion.k31.com
    dig www.k31.com
fi

echo "=== Konfigurasi DNS Master-Slave dan resolver selesai! ==="
