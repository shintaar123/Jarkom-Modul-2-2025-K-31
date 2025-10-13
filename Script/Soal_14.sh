#!/bin/bash
# ===========================================
# Soal 14: Catatan Kedatangan yang Jujur 📝
# Konfigurasi Sirion (Proxy) & Vingilot (Backend)
# untuk mencatat IP asli klien menggunakan X-Forwarded-For
# ===========================================

echo "=== [1/4] Backup konfigurasi lama ==="
cp /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-available/reverse-proxy.bak 2>/dev/null
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak 2>/dev/null
cp /etc/nginx/sites-available/app.k31.com /etc/nginx/sites-available/app.k31.com.bak 2>/dev/null

echo "=== [2/4] Menulis ulang konfigurasi reverse proxy di Sirion ==="
cat <<'EOF' > /etc/nginx/sites-available/reverse-proxy
# Blok untuk menangani akses non-kanonikal (IP & hostname)
server {
    listen 80;
    listen 443 ssl;
    server_name 10.79.3.2 sirion.k31.com;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    return 301 https://www.k31.com$request_uri;
}

# Blok untuk mengalihkan HTTP ke HTTPS (nama kanonikal)
server {
    listen 80;
    server_name www.k31.com k31.com;
    return 301 https://$host$request_uri;
}

# Blok utama HTTPS untuk proxy
server {
    listen 443 ssl;
    server_name www.k31.com k31.com;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers off;

    access_log /var/log/nginx/reverse-access.log;
    error_log /var/log/nginx/reverse-error.log;

    location /static/ {
        proxy_pass http://10.79.3.5/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /app/ {
        proxy_pass http://10.79.3.6/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        # Titipkan IP asli klien
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        root /var/www/sirion;
        index index.html;
    }
}
EOF

echo "=== [3/4] Konfigurasi Vingilot untuk membaca header X-Forwarded-For ==="
# Tambahkan format log baru di nginx.conf
sed -i '/http {/a \
    # Logging format untuk koneksi via proxy\n    log_format proxied '\''$http_x_forwarded_for - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'\'';\n' /etc/nginx/nginx.conf

# Edit file site app.k31.com agar pakai log_format proxied
cat <<'EOF' > /etc/nginx/sites-available/app.k31.com
server {
    listen 80;
    server_name app.k31.com;

    root /var/www/app;
    index index.html;

    access_log /var/log/nginx/app_access.log proxied;
    error_log  /var/log/nginx/app_error.log;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

echo "=== [4/4] Uji konfigurasi dan reload Nginx ==="
nginx -t && systemctl restart nginx

echo "✅ Konfigurasi Soal 14 selesai."
echo "Silakan uji dengan: curl -k https://www.k31.com/app/"
echo "Lalu periksa log di Vingilot: tail -n 1 /var/log/nginx/app_access.log"
echo "Jika IP yang muncul adalah IP Earendil (10.79.1.2), konfigurasi BERHASIL 🎉"
