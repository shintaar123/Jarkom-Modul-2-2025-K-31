#!/bin/bash
# =============================================
# SOAL 10 - Konfigurasi Web Server PHP (app.k31.com)
# Host: VINGILOT
# =============================================

echo "===== [1] Instalasi NGINX dan PHP-FPM ====="
apt update && apt install -y nginx php php-fpm

echo "===== [2] Pastikan PHP-FPM aktif dan socket tersedia ====="
service php8.4-fpm start
ls /run/php
echo "Pastikan terdapat file seperti /run/php/php8.4-fpm.sock"

echo "===== [3] Buat folder web /var/www/app dan isi file PHP ====="
mkdir -p /var/www/app
chown -R www-data:www-data /var/www/app
chmod -R 755 /var/www/app

cat > /var/www/app/index.php <<'EOF'
<?php
echo "<h1>Welcome to app.k31.com</h1>";
echo "<p>This is the homepage served by PHP-FPM on Vingilot.</p>";
echo "<p><a href='/about'>About</a></p>";
?>
EOF

cat > /var/www/app/about.php <<'EOF'
<?php
echo "<h1>About app.k31.com</h1>";
echo "<p>This is the About page. URL without .php should work: /about</p>";
echo "<p><a href='/'>Home</a></p>";
?>
EOF

echo "===== [4] Konfigurasi server block app.k31.com ====="
cat > /etc/nginx/sites-available/app.k31.com <<'EOF'
server {
    listen 80;
    server_name app.k31.com;
    root /var/www/app;
    index index.php index.html;

    access_log /var/log/nginx/app_access.log;
    error_log  /var/log/nginx/app_error.log;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location = /about {
        rewrite ^ /about.php last;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

echo "===== [5] Aktifkan konfigurasi app.k31.com dan hapus default ====="
ln -sf /etc/nginx/sites-available/app.k31.com /etc/nginx/sites-enabled/app.k31.com
rm -f /etc/nginx/sites-enabled/default

echo "===== [6] Tes konfigurasi dan restart nginx ====="
nginx -t
service nginx restart

echo "===== [7] Tes hasil akses ====="
curl -I http://app.k31.com/
curl -I http://app.k31.com/about
curl http://app.k31.com/about | head -n 20

echo "===== Konfigurasi Soal 10 selesai. ====="
