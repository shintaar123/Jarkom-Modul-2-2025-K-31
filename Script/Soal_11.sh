#!/bin/bash
#
# Skrip Pengerjaan Soal 11 - Konfigurasi Reverse Proxy (Sirion)
#
# Skrip ini akan mengkonfigurasi node SIRION sebagai reverse proxy
# yang me-routing /static/ ke Lindon dan /app/ ke Vingilot.
#

# Hentikan skrip jika ada perintah yang gagal
set -e

# --- 1. Instalasi Nginx ---
echo "[Soal 11] Memulai instalasi Nginx..."
apt-get update > /dev/null
apt-get install -y nginx > /dev/null
echo "[Soal 11] Nginx berhasil diinstal."

# --- 2. Membuat File Konfigurasi Reverse Proxy ---
echo "[Soal 11] Membuat file konfigurasi di /etc/nginx/sites-available/reverse-proxy.conf..."
cat > /etc/nginx/sites-available/reverse-proxy.conf <<'EOF'
# Definisikan backend server
upstream static_backend {
    # Lindon (10.79.3.5)
    server 10.79.3.5;
}
upstream app_backend {
    # Vingilot (10.79.3.6)
    server 10.79.3.6;
}

server {
    listen 80;
    server_name www.k31.com sirion.k31.com;

    access_log /var/log/nginx/reverse_access.log;
    error_log  /var/log/nginx/reverse_error.log;

    # Aturan routing untuk /static/
    location /static/ {
        # Trailing slash (http://.../) penting untuk menghapus /static/
        proxy_pass http://static_backend/;
        
        # Teruskan header yang diminta di soal
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Aturan routing untuk /app/
    location /app/ {
        # Trailing slash (http://.../) penting untuk menghapus /app/
        proxy_pass http://app_backend/;
        
        # Teruskan header yang diminta di soal
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # (Opsional) Halaman root default untuk Sirion
    location / {
        return 200 "Sirion Reverse Proxy [Soal 11] Aktif.\nCoba /static/annals/ atau /app/about\n";
        add_header Content-Type text/plain;
    }
}
EOF
echo "[Soal 11] File konfigurasi berhasil dibuat."

# --- 3. Mengaktifkan Konfigurasi ---
echo "[Soal 11] Mengaktifkan site 'reverse-proxy.conf'..."
# Hapus link lama jika ada, lalu buat yang baru
ln -sf /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

echo "[Soal 11] Menonaktifkan site 'default'..."
rm -f /etc/nginx/sites-enabled/default

# --- 4. Tes dan Restart Nginx ---
echo "[Soal 11] Mengetes sintaks konfigurasi Nginx..."
nginx -t
# Jika 'nginx -t' gagal, 'set -e' akan menghentikan skrip di sini

echo "[Soal 11] Merestart layanan Nginx..."
service nginx restart

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 11 Selesai. Sirion kini menjadi Reverse Proxy."
echo "--------------------------------------------------------"
echo "Lakukan verifikasi dari node Earendil/Elrond:"
echo "  curl http://www.k31.com/static/annals/"
echo "  curl http://www.k31.com/app/"
echo "  curl http://www.k31.com/app/about"
echo ""
