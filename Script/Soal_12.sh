#!/bin/bash
# Soal_12.sh - HTTPS Reverse Proxy di Sirion

# Instalasi dan pembuatan sertifikat SSL
apt update && apt install openssl -y
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt

# Konfigurasi Nginx untuk HTTPS
cat > /etc/nginx/sites-available/reverse-proxy <<'EOF'
server {
    listen 80;
    server_name www.k31.com k31.com;
    return 301 https://$host$request_uri;
}

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
    }

    location /app/ {
        proxy_pass http://10.79.3.6/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        root /var/www/sirion;
        index index.html;
    }
}
EOF

# Aktifkan konfigurasi dan terapkan
ln -sf /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
nginx -t
nginx -s reload

# Tes dari client (jalankan manual dari Earendil/Elrond)
# curl -I http://www.k31.com
# curl -k https://www.k31.com/app/
# curl -k https://www.k31.com/static/annals/
