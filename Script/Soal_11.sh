#!/bin/bash
# =============================================
# SOAL 11 - Reverse Proxy Nginx
# Host: SIRION (10.79.3.2)
# =============================================

echo "===== [1] Bersihkan konfigurasi lama ====="
rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/sites-available/*
mkdir -p /var/www/sirion
mkdir -p /var/log/nginx/

echo "===== [2] Buat halaman tes utama ====="
echo "<h1>Welcome to Sirion Reverse Proxy</h1><br><a href='/app/'>App</a> | <a href='/static/'>Static</a>" > /var/www/sirion/index.html

echo "===== [3] Buat konfigurasi reverse proxy ====="
cat > /etc/nginx/sites-available/reverse-proxy <<'EOF'
server {
    listen 80;
    server_name www.k31.com sirion.k31.com;

    # Route ke Lindon (web statis)
    location /static/ {
        proxy_pass http://10.79.3.5/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Route ke Vingilot (web dinamis)
    location /app/ {
        proxy_pass http://10.79.3.6/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Halaman utama
    location / {
        root /var/www/sirion;
        index index.html;
    }
}
EOF

echo "===== [4] Aktifkan konfigurasi dan reload Nginx ====="
ln -sf /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
nginx -t
nginx -s reload

echo "===== [5] Tes langsung di Sirion ====="
echo "--> Menguji koneksi backend Lindon (static)"
curl -s http://127.0.0.1/static/ | head -n 5
echo "--> Menguji koneksi backend Vingilot (app)"
curl -s http://127.0.0.1/app/ | head -n 5

echo "===== [6] Tes dari client (Earendil / Elrond) ====="
echo "Di client, jalankan:"
echo "curl http://www.k31.com/static/"
echo "curl http://www.k31.com/app/"
echo "Hasil yang diharapkan:"
echo "- /static/ menampilkan konten dari Lindon"
echo "- /app/ menampilkan konten PHP dari Vingilot"

echo "===== [7] (Opsional) Tambahkan auto-start nginx ====="
cat > /etc/rc.local <<'EOF'
#!/bin/bash
service nginx restart
exit 0
EOF
chmod +x /etc/rc.local
bash /etc/rc.local

echo "===== Konfigurasi Reverse Proxy (Soal 11) selesai. ====="
