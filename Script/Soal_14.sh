#!/bin/bash
#
# Skrip Pengerjaan Soal 14 - Konfigurasi Real IP (Vingilot)
#
# Skrip ini akan mengkonfigurasi Nginx di VINGILOT untuk
# membaca IP Klien asli dari header X-Real-IP yang dikirim Sirion.
#

# Hentikan skrip jika ada perintah yang gagal
set -e

echo "[Soal 14] Memulai skrip di Vingilot..."

# --- 1. Memodifikasi /etc/nginx/nginx.conf ---
# Kita tambahkan 3 baris (set_real_ip_from, real_ip_header)
# Skrip ini mengecek dulu agar tidak duplikat

CONFIG_FILE="/etc/nginx/nginx.conf"
REAL_IP_CONFIG="\
    # --- TAMBAHAN SOAL 14: Konfigurasi Real IP ---\n\
    set_real_ip_from 10.79.3.2;   # IP Sirion (Proxy Tepercaya)\n\
    real_ip_header X-Real-IP;\n\
    # --- BATAS TAMBAHAN ---\n"

if grep -q "real_ip_header X-Real-IP;" "$CONFIG_FILE"; then
    echo "[Soal 14] Konfigurasi Real-IP sudah ada di $CONFIG_FILE."
else
    echo "[Soal 14] Menambahkan konfigurasi Real-IP ke $CONFIG_FILE..."
    # Menambahkan konfigurasi Real-IP di dalam blok http {},
    # tepat sebelum baris 'include /etc/nginx/sites-enabled/*'
    sed -i "/include \/etc\/nginx\/sites-enabled\//i $REAL_IP_CONFIG" "$CONFIG_FILE"
fi


# --- 2. Memperbaiki Konfigurasi 'app.k31.com' ---
# Kita timpa file ini untuk memastikan 'access_log' ada (memperbaiki error)
echo "[Soal 14] Memperbaiki /etc/nginx/sites-available/app.k31.com..."
cat > /etc/nginx/sites-available/app.k31.com <<'EOF'
server {
    listen 80;
    server_name app.k31.com;
    root /var/www/app;
    index index.php;

    # --- INI WAJIB ADA UNTUK SOAL 14 ---
    access_log /var/log/nginx/app_access.log;
    error_log  /var/log/nginx/app_error.log;
    # -----------------------------------

    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    location = /about {
        rewrite ^ /about.php last;
    }
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        # Pastikan path socket ini benar!
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF
echo "[Soal 14] File 'app.k31.com' berhasil diperbaiki."

# --- 3. Mengaktifkan Site dan Menonaktifkan Default ---
echo "[Soal 14] Mengaktifkan site 'app.k31.com'..."
ln -sf /etc/nginx/sites-available/app.k31.com /etc/nginx/sites-enabled/

echo "[Soal 14] Menonaktifkan site 'default'..."
rm -f /etc/nginx/sites-enabled/default

# --- 4. Tes dan Restart Nginx ---
echo "[Soal 14] Mengetes sintaks konfigurasi Nginx..."
nginx -t
# Jika 'nginx -t' gagal, 'set -e' akan menghentikan skrip di sini

echo "[Soal 14] Merestart layanan Nginx..."
service nginx restart

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 14 Selesai. Vingilot kini siap mencatat IP asli."
echo "--------------------------------------------------------"
echo "Lakukan verifikasi:"
echo "1. Dari EARENDIL: curl http://www.k31.com/app/"
echo "2. Kembali ke VINGILOT ini, jalankan:"
echo "   tail -n 1 /var/log/nginx/app_access.log"
echo ""
