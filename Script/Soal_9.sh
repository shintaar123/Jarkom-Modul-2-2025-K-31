#!/bin/bash
# =============================================
# SOAL 9 - Konfigurasi Web Server static.k31.com
# Host: LINDON
# =============================================

echo "===== [1] Instalasi NGINX ====="
apt update && apt install -y nginx

echo "===== [2] Buat folder /var/www/annals dan isi contoh file ====="
mkdir -p /var/www/annals
echo "Annual report 2023" > /var/www/annals/report-2023.txt
echo "Logbook 2024" > /var/www/annals/log-2024.txt
chown -R www-data:www-data /var/www/annals
chmod -R 755 /var/www/annals

echo "===== [3] Konfigurasi server block static.k31.com ====="
cat > /etc/nginx/sites-available/static.k31.com <<'EOF'
server {
    listen 80;
    server_name static.k31.com;

    root /var/www;

    access_log /var/log/nginx/static_access.log;
    error_log  /var/log/nginx/static_error.log;

    location /annals/ {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        allow all;
    }

    location ~ \.php$ {
        return 404;
    }
}
EOF

echo "===== [4] Aktifkan site dan restart nginx ====="
ln -s /etc/nginx/sites-available/static.k31.com /etc/nginx/sites-enabled/static.k31.com
rm -f /etc/nginx/sites-enabled/default
nginx -t
service nginx restart

echo "===== [5] Verifikasi NGINX listening di port 80 ====="
ss -ltnp | grep ':80' || netstat -ltnp | grep ':80'

echo "===== [6] Tes akses lokal ====="
curl -I http://localhost/annals/
curl http://localhost/annals/

echo "===== [7] Verifikasi DNS dari Tirion & Valmar ====="
dig @10.79.3.3 static.k31.com A +short
dig @10.79.3.4 static.k31.com A +short

echo "===== [8] Tes akses dari Earendil & Elrond ====="
echo "Cek resolv.conf dan akses via curl:"
echo "cat /etc/resolv.conf"
echo "dig static.k31.com +short"
echo "curl -I http://static.k31.com/annals/"
echo "curl http://static.k31.com/annals/ | head -n 40"

echo "===== Konfigurasi Soal 9 selesai. ====="
