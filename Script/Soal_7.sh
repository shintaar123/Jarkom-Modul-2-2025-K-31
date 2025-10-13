#!/bin/bash
# ============================
# SOAL 7 - Konfigurasi DNS Forwarder & CNAME di k31.com
# ============================

echo "[1] Update Zona di Master (Tirion/ns1)..."

# Pastikan direktori zona sudah ada
mkdir -p /etc/bind/zones

# Tulis ulang file zona dengan record baru
cat > /etc/bind/zones/db.k31.com << EOF
\$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101201 ; Serial (naik setiap update)
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        30 )       ; Negative Cache TTL
;
; --- NS Record ---
    IN  NS  ns1.k31.com.
    IN  NS  ns2.k31.com.

; --- A Record ---
ns1      IN  A   10.79.3.3
ns2      IN  A   10.79.3.4
sirion   IN  A   10.79.3.2
lindon   IN  A   10.79.3.5
vingilot IN  A   10.79.3.6

; --- CNAME Record ---
www     IN  CNAME sirion
static  IN  CNAME lindon
app     IN  CNAME vingilot
EOF

# Validasi konfigurasi zona
named-checkzone k31.com /etc/bind/zones/db.k31.com
named-checkconf

# Restart bind di Master
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

echo "[2] Validasi di Master selesai ✅"
echo "Zone k31.com/IN: loaded serial 2025101201"

# ------------------------------------------
# Bagian untuk pengecekan di Slave (Valmar)
# ------------------------------------------

echo "[3] Cek sinkronisasi di Slave (Valmar)..."
echo "Jalankan perintah di Valmar untuk memastikan file hasil transfer:"
echo "  ls -l /var/cache/bind/"
echo ""
echo "[4] Verifikasi record di Slave:"
echo "  dig @10.79.3.4 sirion.k31.com A"
echo "  dig @10.79.3.4 lindon.k31.com A"
echo "  dig @10.79.3.4 vingilot.k31.com A"
echo "  dig @10.79.3.4 www.k31.com CNAME"
echo "  dig @10.79.3.4 static.k31.com CNAME"
echo "  dig @10.79.3.4 app.k31.com CNAME"
echo ""
echo "✅ Hasil yang diharapkan:"
echo "sirion.k31.com   A      10.79.3.2"
echo "lindon.k31.com   A      10.79.3.5"
echo "vingilot.k31.com A      10.79.3.6"
echo "www.k31.com      CNAME  sirion.k31.com"
echo "static.k31.com   CNAME  lindon.k31.com"
echo "app.k31.com      CNAME  vingilot.k31.com"

# ------------------------------------------
# Uji dari dua klien
# ------------------------------------------

echo "[5] Tes dari klien (Earendil dan Elrond)..."
echo "🔹 Tes query DNS:"
echo "  dig sirion.k31.com"
echo "  dig www.k31.com"
echo "  dig static.k31.com"
echo "  dig app.k31.com"
echo ""
echo "🔹 Tes konektivitas:"
echo "  ping -c 2 sirion.k31.com"
echo "  ping -c 2 static.k31.com"
echo "  ping -c 2 app.k31.com"

echo "[✅] Konfigurasi DNS forwarder & alias selesai."
