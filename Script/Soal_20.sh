#!/bin/bash
#
# Skrip Pengerjaan Soal 20 - Pembuatan Halaman Beranda
#
# !! JALANKAN INI DI SERVER REVERSE PROXY (SIRION) !!
#
# Skrip ini akan:
# 1. Membuat file /var/www/html/index.html baru.
# 2. Mengkonfigurasi ulang Nginx untuk menyajikan file ini di location /.
# 3. Merestart Nginx.
#

# Hentikan skrip jika ada perintah yang gagal
set -e

echo "[Soal 20] Memulai skrip di Sirion..."

# --- 1. Membuat Halaman HTML Beranda ---
echo "[Soal 20] Membuat direktori /var/www/html..."
mkdir -p /var/www/html

echo "[Soal 20] Membuat file /var/www/html/index.html..."
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="id">
<head>
    <title>War of Wrath</title>
    <meta charset="UTF-8">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #2c3e50; 
            color: #ecf0f1; 
            margin: 40px; 
            line-height: 1.6;
        }
        h1 { color: #f1c40f; }
        a { color: #3498db; }
        a:hover { color: #5dade2; }
        ul { list-style: none; padding-left: 0; }
        li { margin-bottom: 10px; }
    </style>
</head>
<body>
    <h1>War of Wrath: Lindon bertahan</h1>
    <p>Kisah ditutup di beranda Sirion. Telusuri tautan layanan:</p>
    <ul>
        <li><a href="/app/">[ APP ] Layanan Dinamis (Vingilot)</a></li>
        <li><a href="/static/annals/">[ STATIC ] Arsip Statis (Lindon)</a></li>
    </ul>
</body>
</html>
EOF

# --- 2. Menimpa Konfigurasi Nginx dengan Versi Final ---
# Ini adalah cara teraman untuk mengganti 'location /'
echo "[Soal 20] Menimpa /etc/nginx/sites-available/reverse-proxy.conf..."
cat > /etc/nginx/sites-available/reverse-proxy.conf <<'EOF'
# --- 1. DEFINISI UPSTREAM ---
upstream static_backend {
    server 10.79.3.5;
}
upstream app_backend {
    server 10.79.3.6;
}

# --- 2. BLOK SERVER (NOMOR 13 - KANONISASI) ---
server {
    listen 80 default_server;
    server_name sirion.k31.com;
    return 301 http://www.k31.com$request_uri;
}

# --- 3. BLOK SERVER KANONIK (www + havens) ---
server {
    listen 80;
    server_name www.k31.com havens.k31.com; # Dari Soal 19

    access_log /var/log/nginx/reverse_access.log;
    error_log  /var/log/nginx/reverse_error.log;

    # --- LOKASI BARU (NOMOR 20 - HOMEPAGE) ---
    location / {
        root /var/www/html;
        index index.html;
        try_files $uri $uri/ =404;
    }

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
}
EOF
echo "[Soal 20] File konfigurasi berhasil ditulis ulang."

# --- 3. Tes dan Restart Nginx ---
echo "[Soal 20] Mengetes sintaks konfigurasi Nginx..."
nginx -t
# Jika 'nginx -t' gagal, 'set -e' akan menghentikan skrip di sini

echo "[Soal 20] Merestart layanan Nginx..."
service nginx restart

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 20 Selesai. Beranda Sirion sudah aktif."
echo "--------------------------------------------------------"
echo "Lakukan verifikasi dari node Earendil/Elrond:"
echo "  curl http://www.k31.com/"
echo "  curl http://havens.k31.com/static/annals/"
echo ""
