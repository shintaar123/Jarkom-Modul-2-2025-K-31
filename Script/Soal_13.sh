#!/bin/bash
apt update && apt install nginx openssl -y

# Edit konfigurasi reverse proxy
cat > /etc/nginx/sites-available/reverse-proxy <<'EOF'
# Blok BARU untuk menangani akses non-kanonikal (IP & hostname)
server {
    listen 80;
    listen 443 ssl;
    server_name 10.79.3.2 sirion.k31.com;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    return 301 https://www.k31.com$request_uri;
}

# Blok untuk mengalihkan HTTP ke HTTPS (khusus untuk nama kanonikal)
server {
    listen 80;
    server_name www.k31.com k31.com;
    return 301 https://$host$request_uri;
}

# Blok utama untuk melayani HTTPS (nama kanonikal)
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

# Uji sintaks konfigurasi
nginx -t

# Terapkan konfigurasi baru
nginx -s reload
