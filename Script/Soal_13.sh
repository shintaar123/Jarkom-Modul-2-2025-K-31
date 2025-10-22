#!/bin/bash
#
# Skrip Pengerjaan Soal 13 - Kanonisasi Endpoint (Redirect 301)
#
# Skrip ini akan memodifikasi konfigurasi Nginx (dari Soal 12)
# untuk me-redirect semua trafik non-kanonik (via IP atau sirion.k31.com)
# ke hostname kanonik (www.k31.com).
#
# *ASUMSI: Dijalankan setelah Soal 12 selesai.*
#

# Hentikan skrip jika ada perintah yang gagal
set -e

echo "[Soal 13] Memulai konfigurasi kanonisasi..."

# --- 1. Menimpa Konfigurasi Nginx ---
echo "[Soal 13] Menimpa /etc/nginx/sites-available/reverse-proxy.conf..."
# Kita timpa file konfigurasi dari Soal 12 dengan versi baru
# yang memiliki dua blok server untuk kanonisasi.
cat > /etc/nginx/sites-available/reverse-proxy.conf <<'EOF'
# --- 1. DEFINISI UPSTREAM (HARUS DI PALING LUAR) ---
upstream static_backend {
    # Lindon (10.79.3.5)
    server 10.79.3.5;
}
upstream app_backend {
    # Vingilot (10.79.3.6)
    server 10.79.3.6;
}

# --- 2. BLOK SERVER BARU (NOMOR 13) ---
# Server ini menangkap trafik non-kanonik (IP dan 'sirion')
server {
    # 'default_server' menangkap semua request via IP (10.79.3.2)
    listen 80 default_server;
    
    # Juga menangkap request ke hostname 'sirion'
    server_name sirion.k31.com;

    # Redirect permanen (301) semua request ke 'www'
    return 301 http://www.k31.com$request_uri;
}

# --- 3. BLOK SERVER LAMA (UNTUK 'www.k31.com') ---
# Server ini HANYA melayani nama kanonik 'www.k31.com'
server {
    listen 80;
    
    # Hanya 'www.k31.com' yang tersisa di sini
    server_name www.k31.com;

    access_log /var/log/nginx/reverse_access.log;
    error_log  /var/log/nginx/reverse_error.log;

    # --- Lokasi dari Soal 12 ---
    location /admin/ {
        auth_basic "Restricted Admin Area";
        auth_basic_user_file /etc/nginx/.htpasswd;
        proxy_pass http://app_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # --- Lokasi dari Soal 11 ---
    location /static/ {
        proxy_pass http://static_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # --- Lokasi dari Soal 11 ---
    location /app/ {
        proxy_pass http://app_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location / {
        return 200 "Sirion Reverse Proxy Aktif.\n";
    }
}
EOF
echo "[Soal 13] File konfigurasi berhasil ditulis ulang."

# --- 2. Mengaktifkan Konfigurasi (Jika belum) ---
# Skrip ini mengasumsikan file sudah diaktifkan di Soal 11
ln -sf /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
rm -f /etc/nginx/sites-enabled/default

# --- 3. Tes dan Restart Nginx ---
echo "[Soal 13] Mengetes sintaks konfigurasi Nginx..."
nginx -t
# Jika 'nginx -t' gagal, 'set -e' akan menghentikan skrip di sini

echo "[Soal 13] Merestart layanan Nginx..."
service nginx restart

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 13 Selesai. Kanonisasi endpoint aktif."
echo "--------------------------------------------------------"
echo "Lakukan verifikasi dari node Earendil/Elrond:"
echo "  curl -I http://10.79.3.2/app/       (Harus 301 Redirect)"
echo "  curl -I http://sirion.k31.com/app/  (Harus 301 Redirect)"
echo "  curl -I http://www.k31.com/app/       (Harus 200 OK)"
echo ""
